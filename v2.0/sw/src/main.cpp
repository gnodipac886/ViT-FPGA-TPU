#include <fcntl.h>
#include <getopt.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>

#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include "dma_utils.h"
#include "accelerator.h"
#include "matrix_utils.h"

#include <torch/torch.h>
#include <ATen/ATen.h>

// #define ADDR 				0x100000000
// #define ADDR_LIMIT 			1 << 16

using namespace torch::indexing;

extern "C" float gemm_padded(torch::Tensor mat_a, torch::Tensor mat_b, torch::Tensor mat_c);
extern "C" float gemm_padded_ptr(float16_t * mat_a_ptr, float16_t * mat_b_ptr, float16_t * mat_c_ptr, int M, int K, int N);
// extern "C" void gemm_ptr(float16_t * mat_a_ptr, float16_t * mat_b_ptr, float16_t * mat_c_ptr, int M, int K, int N);
extern "C" int  get_fpga_matrix_size();

#define SKEW_MAT_SIZE		((MATRIX_SIZE << 1) - 1) // skew matrix size is different that the skew buff size for now
#define SKEW_MAT_BUF_SIZE	(MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t))
#define IN_MATRIX_BUF_SIZE	(MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t))
#define OUT_MATRIX_BUF_SIZE	(MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t))
// #define IN_SKEW_BUF_SIZE	MATRIX_SIZE * SKEW_MAT_SIZE * sizeof(float16_t)

char WRITE_DEV_NAME	[]	= "/dev/xdma0_h2c_0";
char READ_DEV_NAME	[]	= "/dev/xdma0_c2h_0";

int fpga_w_fd = 0;
int fpga_r_fd = 0;

int32_t  mat_ab_size = MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t) * 2;
uint32_t mat_a_addr = 0x0000;
uint32_t mat_b_addr = 0x2000;
uint32_t mat_c_addr	= 0x4000;
uint32_t mat_d_addr	= 0x8000;

int get_fpga_matrix_size() {
	return (int)MATRIX_SIZE;
}

void fpga_write(void * buf, int len, uint32_t addr) {
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)buf, len, addr);
}

void fpga_read(void * buf, int len, uint32_t addr) {
	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)buf, len, addr);
}

void fpga_reg_write(uint32_t data, uint64_t addr) {
	fpga_data_t * fpga_data = (fpga_data_t *)aligned_alloc(FPGA_DATA_WIDTH, sizeof(fpga_data_t));
	fpga_data->data[0] = data;
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)fpga_data, sizeof(fpga_data_t), addr);
	free(fpga_data);
}

void fpga_reg_read(void * buf, uint64_t addr) {
	fpga_data_t * fpga_data = (fpga_data_t *)aligned_alloc(FPGA_DATA_WIDTH, sizeof(fpga_data_t));
	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)fpga_data, sizeof(fpga_data_t), addr);
	((uint32_t*)buf)[0] = fpga_data->data[0];
	free(fpga_data);
}

void issue_accel_instr(accel_instr_e instr, int block) {
	uint32_t state = 0x1;
	fpga_reg_write((uint32_t)instr, R_ACCEL_INSTR);
	// std::cout << "wrote to fpga instr reg" << std::endl;

	// wait for state to be idle again
	// TODO: might need to be R_ACCEL_INSTR 
	while (state && block) {
		// std::cout << "being blocked" << std::endl;
		fpga_reg_read(&state, R_ACCEL_INSTR);
	}
}

void matmul_sync(){
	uint32_t state = 0x1;
	while (state) {
		// std::cout << "being blocked" << std::endl;
		fpga_reg_read(&state, R_ACCEL_INSTR);
	}
}

void write_mat_ab(float16_t * mat_a_buf, float16_t * mat_b_buf, uint32_t mat_len, uint32_t fpga_num_mm) {
	uint32_t state = 0x1;

	// write the matrix A into FPGA
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_a_buf, mat_len, mat_a_addr);
	// std::cout << "wrote to main dram" << std::endl;

	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_b_buf, mat_len, mat_b_addr);

	// TODO: this can all be simplified into one call to write to all the registers
	// write the matrix address into the FPGA register
	fpga_reg_write(mat_a_addr, R_MATRIX_A_ADDR);
	fpga_reg_write(mat_b_addr, R_MATRIX_B_ADDR);
	printf("A ADDR: %x, B ADDR: %x, NUM MM: %d, MAT_M_SIZE: %d\n", mat_a_addr, mat_b_addr, fpga_num_mm, 1);
	// std::cout << "wrote to fpga addr reg" << std::endl;

	// write the matrix length into the FPGA register
	fpga_reg_write(mat_len, R_MATRIX_A_SIZE);
	fpga_reg_write(mat_len, R_MATRIX_B_SIZE);
	// std::cout << "wrote to fpga size reg" << std::endl;

	fpga_reg_write(fpga_num_mm, R_MATRIX_RD_CNT);
}

void write_mat_ab_all(float16_t * mat_ab_buf, uint32_t fpga_num_mm, uint32_t mat_m_size) {
	uint32_t state = 0x1;
	uint64_t total_mat_ab_size 	= fpga_num_mm * mat_ab_size;
	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
	uint64_t mat_ab_offset = fpga_num_mm * skew_buf_size;
	// mat_a_addr = 0x00000;
	mat_b_addr = mat_a_addr + total_mat_ab_size;
	mat_c_addr = mat_b_addr + total_mat_ab_size;
	// mat_c_addr	= 2 * total_mat_ab_size + 0x20000;

	// write both matrix A and B into FPGA
	// std::cout << "writing from buffer" << std::endl;
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_ab_buf, mat_ab_offset*2, mat_a_addr);

	// TODO: this can all be simplified into one call to write to all the registers
	// write the matrix address into the FPGA register
	// std::cout << "writing to fpga addr reg" << std::endl;
	fpga_reg_write(mat_a_addr, R_MATRIX_A_ADDR);
	fpga_reg_write(mat_b_addr, R_MATRIX_B_ADDR);
	fpga_reg_write(mat_c_addr, R_MATRIX_C_ADDR);
	// std::cout << "wrote to fpga addr reg" << std::endl;

	// write the matrix length into the FPGA register
	// std::cout << "writing to fpga size reg" << std::endl;
	fpga_reg_write(MATRIX_SIZE * SKEW_MAT_SIZE * sizeof(float16_t), R_MATRIX_A_SIZE);
	fpga_reg_write(MATRIX_SIZE * SKEW_MAT_SIZE * sizeof(float16_t), R_MATRIX_B_SIZE);
	// std::cout << "wrote to fpga size reg" << std::endl;

	//printf("A ADDR: %x, B ADDR: %x, NUM MM: %d, MAT_M_SIZE: %d\n", mat_a_addr, mat_b_addr, fpga_num_mm, mat_m_size);
	fpga_reg_write(fpga_num_mm, R_MATRIX_RD_CNT);
	fpga_reg_write(mat_m_size, R_MATRIX_M_SIZE);
}

// takes in 2 skewed and transposed matricies, writes back to mat_c_buf
// fpga_num_mm should be an integer multiple of mat_m_size
float fpga_gemm(float16_t * mat_a_buf, float16_t * mat_b_buf, float16_t * mat_c_buf, uint32_t fpga_num_mm, uint32_t mat_m_size, bool blocking, bool time) {
	struct timespec start, end;
	float delta_s;
	uint64_t mat_ab_offset 		= fpga_num_mm * MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
	uint64_t mat_c_size 		= OUT_MATRIX_BUF_SIZE;

	// make a single big buffer to hold both
	float16_t * mat_ab_buf 		= (float16_t *)malloc(2 * mat_ab_offset);

	// printf("gonna do gemm now\n");
	memcpy(mat_ab_buf, mat_a_buf, mat_ab_offset);
	memcpy((void*)((uint64_t)mat_ab_buf + mat_ab_offset), mat_b_buf, mat_ab_offset);
	// printf("gonna do gemm now\n");

	// print_imatrix((float16_t *)mat_ab_buf, (MATRIX_SIZE * fpga_num_mm * 2)*2, MATRIX_SIZE, sizeof(float16_t));

	// open the fpga file
	// fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	// fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	// TODO: RESET
	// fpga_reg_write(I_RESET, R_ACCEL_INSTR);


	// write both matrix A and B into the FPGA DRAM
	write_mat_ab_all(mat_ab_buf, fpga_num_mm, mat_m_size);

	// read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)mat_ab_buf, 2 * mat_ab_offset, 0x0);
	// std::cout << "printing what's been written" << std::endl;
	// print_imatrix((float16_t *)mat_ab_buf, (MATRIX_SIZE * fpga_num_mm * 2)*2, MATRIX_SIZE, sizeof(float16_t));

	// issue the gemm instruction
	
	if (time) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &start);
	}
	issue_accel_instr(I_R_MAT_A, blocking);

	if (time) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &end);
		uint64_t delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000;
		delta_s = float(delta_us) / 1000000.0;
	}

	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)(mat_c_buf), mat_c_size,  mat_c_addr);
	// printf("matrix a addr: %x\n", mat_a_addr);
	// printf("matrix b addr: %x\n", mat_b_addr);
	// printf("matrix c addr: %x\n", mat_c_addr);

	

	free(mat_ab_buf);

	if (time) {
		return delta_s;
	}

	return 0;
	// close(fpga_w_fd);
	// close(fpga_r_fd);
}

// void gemm_ptr(float16_t * mat_a_ptr, float16_t * mat_b_ptr, float16_t * mat_c_ptr, int M, int K, int N) {
// 	int padded_M = std::ceil((float)M / MATRIX_SIZE) * MATRIX_SIZE;
// 	int padded_K = std::ceil((float)K / MATRIX_SIZE) * MATRIX_SIZE;
// 	int padded_N = std::ceil((float)N / MATRIX_SIZE) * MATRIX_SIZE;

// 	torch::Tensor mat_a = torch::from_blob(mat_a_ptr, {M, K}, torch::dtype(torch::kFloat16));
// 	torch::Tensor mat_b = torch::from_blob(mat_b_ptr, {K, N}, torch::dtype(torch::kFloat16));
// 	torch::Tensor mat_c = torch::zeros({padded_M, padded_N}, torch::dtype(torch::kFloat16));

// 	torch::Tensor padded_mat_a = torch::zeros({padded_M, padded_K}, torch::dtype(torch::kFloat16));
// 	torch::Tensor padded_mat_b = torch::zeros({padded_K, padded_N}, torch::dtype(torch::kFloat16));
// 	torch::Tensor padded_mat_c = torch::zeros({padded_M, padded_N}, torch::dtype(torch::kFloat16));

// 	padded_mat_a.index_put_({Slice(0, M, None), Slice(0, K, None)}, mat_a);
// 	padded_mat_b.index_put_({Slice(0, K, None), Slice(0, N, None)}, mat_b);

// 	// gemm_padded(padded_mat_a, padded_mat_b, padded_mat_c);
// 	gemm_padded_ptr((float16_t *)padded_mat_a.data_ptr<at::Half>(), (float16_t *)padded_mat_b.data_ptr<at::Half>(), (float16_t *)padded_mat_c.data_ptr<at::Half>(), padded_M, padded_K, padded_N);

// 	mat_c = padded_mat_c.index({Slice(0, M, None), Slice(0, N, None)});
// 	memcpy(mat_c_ptr, (void*)mat_c.data_ptr<at::Half>(), M * N * sizeof(float16_t));
// }

float gemm_padded_ptr(float16_t * mat_a_ptr, float16_t * mat_b_ptr, float16_t * mat_c_ptr, int M, int K, int N) {
	fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	float time = 0.0;

	torch::Tensor mat_a = torch::from_blob(mat_a_ptr, {M, K}, torch::dtype(torch::kFloat16));
	torch::Tensor mat_b = torch::from_blob(mat_b_ptr, {K, N}, torch::dtype(torch::kFloat16));
	torch::Tensor mat_c = torch::from_blob(mat_c_ptr, {M, N}, torch::dtype(torch::kFloat16));

	int t_M = M / MATRIX_SIZE;  				// number of tiles in M
	int t_N = N / MATRIX_SIZE;  				// number of tiles in K

	int k_tile_size = ((mat_b_addr - mat_a_addr) / SKEW_MAT_BUF_SIZE); // how many skewed matrices can fit in each memory section
	int t_K = K / MATRIX_SIZE; // std::max(1, (K/MATRIX_SIZE) / k_tile_size);

	torch::Tensor mat_b_T = at::transpose_copy(mat_b, 0, 1);

	// std::cout << "M: " << M << ", N: " << N << ", K: " << K << std::endl;
	// std::cout << "t_M: " << t_M << ", t_K: " << t_K << ", t_K: " << t_K << ", k_tile_size: " << k_tile_size << std::endl;

	for (int m = 0; m < t_M; m++) {
		for (int n = 0; n < t_N; n++) {
			for (int k = 0; k < t_K; k++) {

				// prepare all the skew stuff
				int num_sub_mat_K = 1; // (k + 1) * k_tile_size < (K/MATRIX_SIZE) ? k_tile_size : ((K - k * t_K) / MATRIX_SIZE); // number of 16x16 tiles in the K dimension

				torch::Tensor mat_a_tile, mat_b_tile, mat_c_tile;
				torch::Tensor tensor_a_skew_T = torch::zeros({MATRIX_SIZE * 2 * num_sub_mat_K, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
				torch::Tensor tensor_b_skew_T = torch::zeros({MATRIX_SIZE * 2 * num_sub_mat_K, MATRIX_SIZE}, torch::dtype(torch::kFloat16));

				// pytorch c++ is weird
				mat_a_tile = at::transpose_copy(at::transpose_copy(mat_a.index({Slice(m * MATRIX_SIZE, (m + 1) * MATRIX_SIZE, None), Slice(k * MATRIX_SIZE, (k+num_sub_mat_K) * MATRIX_SIZE, None)}), 0, 1), 0, 1);
				mat_b_tile = at::transpose_copy(mat_b.index({Slice(k * MATRIX_SIZE, (k+num_sub_mat_K) * MATRIX_SIZE, None), Slice(n * MATRIX_SIZE, (n + 1) * MATRIX_SIZE, None)}), 0, 1);
				// std::cout << "tile indicies: [" << m * MATRIX_SIZE << ":" << (m + 1) * MATRIX_SIZE << ", " << k * MATRIX_SIZE << ":" << (k+num_sub_mat_K) * MATRIX_SIZE << "]" << std::endl;
				// std::cout << "tile indicies: [" << k * MATRIX_SIZE << ":" << (k+num_sub_mat_K) * MATRIX_SIZE << ", " << n * MATRIX_SIZE << ":" << (n + 1) * MATRIX_SIZE << "]" << std::endl;
				// print_imatrix((float16_t *)mat_b_T.data_ptr<at::Half>(), K, N, sizeof(float16_t));
				
				mat_c_tile = torch::zeros({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));

				// printf("TILES: \n");
				// print_imatrix((float16_t *)mat_a_tile.data_ptr<at::Half>(), MATRIX_SIZE * num_sub_mat_K, MATRIX_SIZE, sizeof(float16_t));
				// print_imatrix((float16_t *)mat_b_tile.data_ptr<at::Half>(), MATRIX_SIZE * num_sub_mat_K, MATRIX_SIZE, sizeof(float16_t));
				// printf("TILES DONE\n");
				// exit(0);

				for (int skew_m = 0; skew_m < num_sub_mat_K; skew_m++) {
					torch::Tensor temp_skew_a = torch::zeros({MATRIX_SIZE, MATRIX_SIZE * 2}, torch::dtype(torch::kFloat16));
					torch::Tensor temp_skew_b = torch::zeros({MATRIX_SIZE, MATRIX_SIZE * 2}, torch::dtype(torch::kFloat16));

					skew_matrix((float16_t*)temp_skew_a.data_ptr<at::Half>(), (float16_t*)mat_a_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t), 1);
					skew_matrix((float16_t*)temp_skew_b.data_ptr<at::Half>(), (float16_t*)mat_b_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t), 1);

					memcpy((void*)(((uint64_t)tensor_a_skew_T.data_ptr<at::Half>()) + skew_m * SKEW_MAT_BUF_SIZE), (void*)at::transpose_copy(temp_skew_a, 0, 1).data_ptr<at::Half>(), SKEW_MAT_BUF_SIZE);
					memcpy((void*)(((uint64_t)tensor_b_skew_T.data_ptr<at::Half>()) + skew_m * SKEW_MAT_BUF_SIZE), (void*)at::transpose_copy(temp_skew_b, 0, 1).data_ptr<at::Half>(), SKEW_MAT_BUF_SIZE);
				}

				// print_imatrix((float16_t *)tensor_a_skew_T.data_ptr<at::Half>(), num_sub_mat_K * MATRIX_SIZE * 2, MATRIX_SIZE, sizeof(float16_t));
				// print_imatrix((float16_t *)tensor_b_skew_T.data_ptr<at::Half>(), num_sub_mat_K * MATRIX_SIZE * 2, MATRIX_SIZE, sizeof(float16_t));

				time += fpga_gemm(	(float16_t *)tensor_a_skew_T.data_ptr<at::Half>(), 
											(float16_t *)tensor_b_skew_T.data_ptr<at::Half>(), 
											(float16_t *)mat_c_tile.data_ptr<at::Half>(), 
											num_sub_mat_K, 
											num_sub_mat_K, 
											true, 
											true
										);
				// print_imatrix((float16_t *)mat_c_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
				mat_c.index({Slice(m * MATRIX_SIZE, (m + 1) * MATRIX_SIZE, None), Slice(n * MATRIX_SIZE, (n + 1) * MATRIX_SIZE, None)}) += mat_c_tile;
				// std::cout << "[" << m * MATRIX_SIZE << ":" << (m + 1) * MATRIX_SIZE << ", " << n * MATRIX_SIZE << ":" << (n + 1) * MATRIX_SIZE << "]" << std::endl;
			}
		}
	}

	// print_imatrix((float16_t *)mat_c.data_ptr<at::Half>(), M, N, sizeof(float16_t));

	memcpy(mat_c_ptr, (void*)mat_c.data_ptr<at::Half>(), M * N * sizeof(float16_t));
	
	close(fpga_w_fd);
	close(fpga_r_fd);

	return time;
}

// perform gemm on a padded matrix to multiples of MATRIX_SIZE
float gemm_padded(torch::Tensor mat_a, torch::Tensor mat_b, torch::Tensor mat_c) { 
	fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	float time = 0.0;

	int M = mat_a.size(0);  					// number of rows in A
	int K = mat_a.size(1); 						// number of columns in B
	int N = mat_b.size(1); 						// number of columns in A and rows in B
	int t_M = M / MATRIX_SIZE;  				// number of tiles in M
	int t_N = N / MATRIX_SIZE;  				// number of tiles in K

	int k_tile_size = ((mat_b_addr - mat_a_addr) / SKEW_MAT_BUF_SIZE); // how many skewed matrices can fit in each memory section
	int t_K = K / MATRIX_SIZE; // std::max(1, (K/MATRIX_SIZE) / k_tile_size);

	torch::Tensor mat_b_T = at::transpose_copy(mat_b, 0, 1);

	// std::cout << "M: " << M << ", N: " << N << ", K: " << K << std::endl;
	// std::cout << "t_M: " << t_M << ", t_K: " << t_K << ", t_K: " << t_K << ", k_tile_size: " << k_tile_size << std::endl;

	for (int m = 0; m < t_M; m++) {
		for (int n = 0; n < t_N; n++) {
			for (int k = 0; k < t_K; k++) {

				// prepare all the skew stuff
				int num_sub_mat_K = 1; // (k + 1) * k_tile_size < (K/MATRIX_SIZE) ? k_tile_size : ((K - k * t_K) / MATRIX_SIZE); // number of 16x16 tiles in the K dimension

				torch::Tensor mat_a_tile, mat_b_tile, mat_c_tile;
				torch::Tensor tensor_a_skew_T = torch::zeros({MATRIX_SIZE * 2 * num_sub_mat_K, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
				torch::Tensor tensor_b_skew_T = torch::zeros({MATRIX_SIZE * 2 * num_sub_mat_K, MATRIX_SIZE}, torch::dtype(torch::kFloat16));

				// pytorch c++ is weird
				mat_a_tile = at::transpose_copy(at::transpose_copy(mat_a.index({Slice(m * MATRIX_SIZE, (m + 1) * MATRIX_SIZE, None), Slice(k * MATRIX_SIZE, (k+num_sub_mat_K) * MATRIX_SIZE, None)}), 0, 1), 0, 1);
				mat_b_tile = at::transpose_copy(mat_b.index({Slice(k * MATRIX_SIZE, (k+num_sub_mat_K) * MATRIX_SIZE, None), Slice(n * MATRIX_SIZE, (n + 1) * MATRIX_SIZE, None)}), 0, 1);
				// std::cout << "tile indicies: [" << m * MATRIX_SIZE << ":" << (m + 1) * MATRIX_SIZE << ", " << k * MATRIX_SIZE << ":" << (k+num_sub_mat_K) * MATRIX_SIZE << "]" << std::endl;
				// std::cout << "tile indicies: [" << k * MATRIX_SIZE << ":" << (k+num_sub_mat_K) * MATRIX_SIZE << ", " << n * MATRIX_SIZE << ":" << (n + 1) * MATRIX_SIZE << "]" << std::endl;
				// print_imatrix((float16_t *)mat_b_T.data_ptr<at::Half>(), K, N, sizeof(float16_t));
				
				mat_c_tile = torch::zeros({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));

				// printf("TILES: \n");
				// print_imatrix((float16_t *)mat_a_tile.data_ptr<at::Half>(), MATRIX_SIZE * num_sub_mat_K, MATRIX_SIZE, sizeof(float16_t));
				// print_imatrix((float16_t *)mat_b_tile.data_ptr<at::Half>(), MATRIX_SIZE * num_sub_mat_K, MATRIX_SIZE, sizeof(float16_t));
				// printf("TILES DONE\n");
				// exit(0);

				for (int skew_m = 0; skew_m < num_sub_mat_K; skew_m++) {
					torch::Tensor temp_skew_a = torch::zeros({MATRIX_SIZE, MATRIX_SIZE * 2}, torch::dtype(torch::kFloat16));
					torch::Tensor temp_skew_b = torch::zeros({MATRIX_SIZE, MATRIX_SIZE * 2}, torch::dtype(torch::kFloat16));

					skew_matrix((float16_t*)temp_skew_a.data_ptr<at::Half>(), (float16_t*)mat_a_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t), 1);
					skew_matrix((float16_t*)temp_skew_b.data_ptr<at::Half>(), (float16_t*)mat_b_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t), 1);

					memcpy((void*)(((uint64_t)tensor_a_skew_T.data_ptr<at::Half>()) + skew_m * SKEW_MAT_BUF_SIZE), (void*)at::transpose_copy(temp_skew_a, 0, 1).data_ptr<at::Half>(), SKEW_MAT_BUF_SIZE);
					memcpy((void*)(((uint64_t)tensor_b_skew_T.data_ptr<at::Half>()) + skew_m * SKEW_MAT_BUF_SIZE), (void*)at::transpose_copy(temp_skew_b, 0, 1).data_ptr<at::Half>(), SKEW_MAT_BUF_SIZE);
				}

				// print_imatrix((float16_t *)tensor_a_skew_T.data_ptr<at::Half>(), num_sub_mat_K * MATRIX_SIZE * 2, MATRIX_SIZE, sizeof(float16_t));
				// print_imatrix((float16_t *)tensor_b_skew_T.data_ptr<at::Half>(), num_sub_mat_K * MATRIX_SIZE * 2, MATRIX_SIZE, sizeof(float16_t));

				time += fpga_gemm(	(float16_t *)tensor_a_skew_T.data_ptr<at::Half>(), 
											(float16_t *)tensor_b_skew_T.data_ptr<at::Half>(), 
											(float16_t *)mat_c_tile.data_ptr<at::Half>(), 
											num_sub_mat_K, 
											num_sub_mat_K, 
											true, 
											true
										);
				// print_imatrix((float16_t *)mat_c_tile.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
				mat_c.index({Slice(m * MATRIX_SIZE, (m + 1) * MATRIX_SIZE, None), Slice(n * MATRIX_SIZE, (n + 1) * MATRIX_SIZE, None)}) += mat_c_tile;
				// std::cout << "[" << m * MATRIX_SIZE << ":" << (m + 1) * MATRIX_SIZE << ", " << n * MATRIX_SIZE << ":" << (n + 1) * MATRIX_SIZE << "]" << std::endl;
			}
		}
	}

	// print_imatrix((float16_t *)mat_c.data_ptr<at::Half>(), M, N, sizeof(float16_t));
	
	close(fpga_w_fd);
	close(fpga_r_fd);

	return time;
}

int main() {
	// A matrix is MxN and B matrix ix NxM
	int MAT_M_TILE_SIZE = 1;
	int MAT_N_TILE_SIZE = 1;
	int MAT_M_SIZE = MATRIX_SIZE * MAT_M_TILE_SIZE;
	int MAT_N_SIZE = MATRIX_SIZE * MAT_N_TILE_SIZE;
	int fpga_num_mm = MAT_M_TILE_SIZE * MAT_N_TILE_SIZE;
	int mat_m_size = MAT_N_TILE_SIZE;
	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t);

	torch::Tensor tensor_a			= torch::full({MATRIX_SIZE * 2, MATRIX_SIZE * 2}, 0.25, torch::dtype(torch::kFloat16));
	set_row_consecutive((float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2);

	// torch::Tensor tensor_a			= torch::eye(MATRIX_SIZE * 2, torch::dtype(torch::kFloat16)) * -6.6;
	torch::Tensor tensor_a_skew		= torch::zeros({MATRIX_SIZE * 2, SKEW_MAT_SIZE * 2}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_a_skew_T;
	// torch::Tensor tensor_b			= torch::eye(MATRIX_SIZE * 2, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b			= torch::full({MATRIX_SIZE * 2, MATRIX_SIZE * 2}, 1.0, torch::dtype(torch::kFloat16));
	// set_eye_matrix_f16((float16_t*)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2);
	set_col_consecutive((float16_t*)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2);

	torch::Tensor tensor_b_skew		= torch::zeros({MATRIX_SIZE * 2, SKEW_MAT_SIZE * 2}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b_skew_T;
	torch::Tensor tensor_c			= torch::zeros({MATRIX_SIZE * 2, MATRIX_SIZE * 2}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);

	// print_imatrix((float16_t *)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2, sizeof(float16_t));
	// print_imatrix((float16_t *)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2, sizeof(float16_t));
	// print_imatrix((float16_t *)tensor_c_golden.data_ptr<at::Half>(), MATRIX_SIZE * 2, MATRIX_SIZE * 2, sizeof(float16_t));
	// printf("printed goldend^^^\n");
	gemm_padded(tensor_a, tensor_b, tensor_c);

	return 0;
}