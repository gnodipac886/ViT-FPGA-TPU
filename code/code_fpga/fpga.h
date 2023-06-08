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

#define ADDR 				0x200000000
#define ADDR_LIMIT 			1 << 16

#define SKEW_MAT_SIZE		((MATRIX_SIZE << 1) - 1)
#define IN_MATRIX_BUF_SIZE	MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t)
#define OUT_MATRIX_BUF_SIZE	MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t)
#define IN_SKEW_BUF_SIZE	MATRIX_SIZE * SKEW_MAT_SIZE * sizeof(float16_t)

char WRITE_DEV_NAME	[]	= "/dev/xdma0_h2c_0";
char READ_DEV_NAME	[]	= "/dev/xdma0_c2h_0";

int fpga_w_fd = 0;
int fpga_r_fd = 0;

int32_t  mat_ab_size = MATRIX_SIZE * MATRIX_SIZE * sizeof(float16_t) * 2;
uint32_t mat_a_addr = 0x0000;
uint32_t mat_b_addr = 0x2000;
uint32_t mat_c_addr	= 0x3000;
uint32_t mat_d_addr	= 0x3000;

void fpga_write(void * buf, int len, uint32_t addr) {
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)buf, len, addr);
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

// {
// 	// write matrix A and B into FPGA
// 	write_mat_ab_all();

// 	// do GEMM
// 	issue_accel_instr(I_R_MAT_A, 0); // 0 for non blocking

// 	// write matrix C into FPGA
// 	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_c_buf, mat_ab_offset, TODO: MAT C ADDR HERE);

// 	// write matrix C addr into FPGA reg
// 	fpga_reg_write(TODO: MAT C ADDR HERE, R_MATRIX_B_ADDR);
// 	fpga_reg_write(fpga_num_mm, R_MATRIX_RD_CNT);
// 	fpga_reg_write(mat_m_size, R_MATRIX_M_SIZE);

// 	// read back matrix A*B
// 	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)mat_c_buf, OUT_MATRIX_BUF_SIZE, mat_c_addr);

// 	// skew matrix A*B
// 	skew_matrix();

// 	// write back matrix A*B
// 	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_axb_buf, mat_ab_offset, TODO: MAT A ADDR HERE);
// 	fpga_reg_write(TODO: MAT A ADDR HERE, R_MATRIX_A_ADDR);

// 	// out matrix c address location
// 	fpga_reg_write(TODO: OUTPUT MAT C ADDR, R_MATRIX_C_ADDR);

// 	// do GEMM
// 	issue_accel_instr(I_R_MAT_A, 1); // 1 for blocking

// 	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)mat_c_buf, OUT_MATRIX_BUF_SIZE, TODO: OUTPUT MAT C ADDR);
// }

void write_mat_ab_all(float16_t * mat_ab_buf, uint32_t fpga_num_mm, uint32_t mat_m_size) {
	uint32_t state = 0x1;
	uint64_t total_mat_ab_size 	= fpga_num_mm * mat_ab_size;
	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
	uint64_t mat_ab_offset = fpga_num_mm * skew_buf_size;
	mat_a_addr = 0x00000;
	mat_b_addr = mat_a_addr + total_mat_ab_size;
	mat_c_addr = mat_b_addr + total_mat_ab_size;
	// mat_c_addr	= 2 * total_mat_ab_size + 0x20000;

	// write both matrix A and B into FPGA
	write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)mat_ab_buf, mat_ab_offset*2, mat_a_addr);

	// TODO: this can all be simplified into one call to write to all the registers
	// write the matrix address into the FPGA register
	fpga_reg_write(mat_a_addr, R_MATRIX_A_ADDR);
	fpga_reg_write(mat_b_addr, R_MATRIX_B_ADDR);
	fpga_reg_write(mat_c_addr, R_MATRIX_C_ADDR);
	// std::cout << "wrote to fpga addr reg" << std::endl;

	// write the matrix length into the FPGA register
	fpga_reg_write(IN_SKEW_BUF_SIZE, R_MATRIX_A_SIZE);
	fpga_reg_write(IN_SKEW_BUF_SIZE, R_MATRIX_B_SIZE);
	// std::cout << "wrote to fpga size reg" << std::endl;

	//printf("A ADDR: %x, B ADDR: %x, NUM MM: %d, MAT_M_SIZE: %d\n", mat_a_addr, mat_b_addr, fpga_num_mm, mat_m_size);
	fpga_reg_write(fpga_num_mm, R_MATRIX_RD_CNT);
	fpga_reg_write(mat_m_size, R_MATRIX_M_SIZE);
}

// takes in 2 skewed and transposed matricies, writes back to mat_c_buf
// fpga_num_mm should be an integer multiple of mat_m_size
double fpga_gemm(float16_t * mat_a_buf, float16_t * mat_b_buf, float16_t * mat_c_buf, uint32_t fpga_num_mm, uint32_t mat_m_size, bool blocking, bool time) {
	struct timespec start, end;
	double delta_s;
	uint64_t total_mat_ab_size 	= fpga_num_mm * IN_SKEW_BUF_SIZE;
	uint64_t mat_ab_offset 		= fpga_num_mm * MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
	uint64_t mat_c_size 		= (fpga_num_mm / mat_m_size) * OUT_MATRIX_BUF_SIZE;

	// make a single big buffer to hold both
	float16_t * mat_ab_buf 		= (float16_t *)malloc(2 * mat_ab_offset);

	printf("gonna do gemm now\n");
	memcpy(mat_ab_buf, mat_a_buf, mat_ab_offset);
	memcpy((void*)((uint64_t)mat_ab_buf + mat_ab_offset), mat_b_buf, mat_ab_offset);
	printf("gonna do gemm now\n");

	// print_imatrix((float16_t *)mat_ab_buf, (MATRIX_SIZE * fpga_num_mm * 2)*2, MATRIX_SIZE, sizeof(float16_t));

	// open the fpga file
	// fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	// fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	// TODO: RESET
	// fpga_reg_write(I_RESET, R_ACCEL_INSTR);

	if (time) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &start);
	}

	// write both matrix A and B into the FPGA DRAM
	write_mat_ab_all(mat_ab_buf, fpga_num_mm, mat_m_size);

	// read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)mat_ab_buf, 2 * mat_ab_offset, 0x0);
	// std::cout << "printing what's been written" << std::endl;
	// print_imatrix((float16_t *)mat_ab_buf, (MATRIX_SIZE * fpga_num_mm * 2)*2, MATRIX_SIZE, sizeof(float16_t));

	// issue the gemm instruction
	
	issue_accel_instr(I_R_MAT_A, blocking);
	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)(mat_c_buf), (fpga_num_mm / mat_m_size) * OUT_MATRIX_BUF_SIZE,  mat_c_addr);
	printf("matrix a addr: %lx\n", mat_a_addr);
	printf("matrix b addr: %lx\n", mat_b_addr);
	printf("matrix c addr: %lx\n", mat_c_addr);
	// read back the resulting matrix C
	// for (int i = 0; i < (fpga_num_mm / mat_m_size); i++) {
	// 	// usleep(1000000);
		// printf("matrix c addr: %lx\n", mat_c_addr + (i * OUT_MATRIX_BUF_SIZE));
	// 	read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)(mat_c_buf + (i * MATRIX_SIZE * MATRIX_SIZE)), OUT_MATRIX_BUF_SIZE,  mat_c_addr+ (i * OUT_MATRIX_BUF_SIZE));
	// 	print_imatrix((float16_t *)mat_c_buf, MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
	// }

	free(mat_ab_buf);
	
	if (time) {
		clock_gettime(CLOCK_MONOTONIC_RAW, &end);
		uint64_t delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000;
		delta_s = double(delta_us) / 1000000.0;
		return delta_s;
	}

	return 0;
	// close(fpga_w_fd);
	// close(fpga_r_fd);
}

int main_exp() {
	// A matrix is MxN and B matrix ix NxM
	for (int i = 0; i < 1; i++) {

	int MAT_M_TILE_SIZE = 2;
	int MAT_N_TILE_SIZE = 3;
	int MAT_M_SIZE = MATRIX_SIZE * MAT_M_TILE_SIZE;
	int MAT_N_SIZE = MATRIX_SIZE * MAT_N_TILE_SIZE;
	int fpga_num_mm = MAT_M_TILE_SIZE * MAT_N_TILE_SIZE;
	int mat_m_size = MAT_N_TILE_SIZE;
	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);

	torch::Tensor tensor_a			= torch::full({MATRIX_SIZE, MATRIX_SIZE}, 0.25, torch::dtype(torch::kFloat16));
	// set_row_col_consecutive((float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE);
	std::cout << tensor_a << std::endl;

	// torch::Tensor tensor_a			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16)) * -6.6;
	torch::Tensor tensor_a_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_a_skew_T;
	// torch::Tensor tensor_b			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b			= torch::full({MATRIX_SIZE, MATRIX_SIZE}, 1.0, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b_skew_T;
	torch::Tensor tensor_c			= torch::zeros({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);

	// std::cout << "Golden Matrix: " << std::endl;
	// print_imatrix((float16_t *)tensor_c_golden.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));

	// std::cout << tensor_a << std::endl;
	skew_matrix((float16_t*)tensor_a_skew.data_ptr<at::Half>(), (float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
	skew_matrix((float16_t*)tensor_b_skew.data_ptr<at::Half>(), (float16_t*)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
	tensor_a_skew_T = at::transpose_copy(tensor_a_skew, 0, 1);
	tensor_b_skew_T = at::transpose_copy(tensor_b_skew, 0, 1);

	float16_t * total_mat_a = (float16_t *)malloc(2 * fpga_num_mm * skew_buf_size);
	float16_t * total_mat_b = (float16_t *)malloc(2 * fpga_num_mm * skew_buf_size);
	for(int i = 0; i < 2 * fpga_num_mm; i++) {
		printf("a%d\n", i);
		memcpy((void*)(((uint64_t)total_mat_a) + i * skew_buf_size), (void*)tensor_a_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
		printf("b%d\n", i);
		memcpy((void*)(((uint64_t)total_mat_b) + i * skew_buf_size), (void*)tensor_b_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
		printf("done\n");
	}
	// print_imatrix((float16_t *)total_mat_b, MATRIX_SIZE * fpga_num_mm * 2, MATRIX_SIZE, sizeof(float16_t));

	fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	double time = fpga_gemm((float16_t *)total_mat_a, (float16_t *)total_mat_b, (float16_t *)tensor_c.data_ptr<at::Half>(), 12, mat_m_size, true, true);
	std::cout << "TIME SPENT: " << time << std::endl;
	//print_imatrix((float16_t *)tensor_c.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));

	close(fpga_w_fd);
	close(fpga_r_fd);
	free(total_mat_a);
	free(total_mat_b);

	}
}

// int other_main() {
// // int main() {
// 	// torch::Tensor tensor_a			= torch::randn({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat64)).to(torch::kFloat16);
// 	torch::Tensor tensor_a			= torch::full({MATRIX_SIZE, MATRIX_SIZE}, 1.0, torch::dtype(torch::kFloat16));
// 	// set_row_col_consecutive((float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE);
// 	// torch::Tensor tensor_a			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16)) * -6.6;
// 	torch::Tensor tensor_a_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
// 	torch::Tensor tensor_a_skew_T;
// 	torch::Tensor tensor_b			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16));
// 	torch::Tensor tensor_b_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
// 	torch::Tensor tensor_b_skew_T;
// 	torch::Tensor tensor_c			= torch::zeros({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
// 	torch::Tensor tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);

// 	// std::cout << tensor_a << std::endl;
// 	skew_matrix((float16_t*)tensor_a_skew.data_ptr<at::Half>(), (float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 	skew_matrix((float16_t*)tensor_b_skew.data_ptr<at::Half>(), (float16_t*)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 	tensor_a_skew_T = at::transpose_copy(tensor_a_skew, 0, 1);
// 	tensor_b_skew_T = at::transpose_copy(tensor_b_skew, 0, 1);
	

// 	fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
// 	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

// 	// // TODO: RESET
// 	// fpga_reg_write(I_RESET, R_ACCEL_INSTR);

// 	// exit(0);

// 	// FPGA
// 	struct timespec start, end;
// 	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
// 	uint64_t loops = 4;

// 	// tensor_a			= torch::full({MATRIX_SIZE, MATRIX_SIZE}, 0.5, torch::dtype(torch::kFloat16));
// 	// std::cout << tensor_a << std::endl;
// 	skew_matrix((float16_t*)tensor_a_skew.data_ptr<at::Half>(), (float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 	tensor_a_skew_T 	= at::transpose_copy(tensor_a_skew, 0, 1);

// 	int mat_m_size = 1;

// 	int MAT_M_TILE_SIZE = 2;
// 	int MAT_N_TILE_SIZE = 2;
// 	int MAT_M_SIZE = MATRIX_SIZE * MAT_M_TILE_SIZE;
// 	int MAT_N_SIZE = MATRIX_SIZE * MAT_N_TILE_SIZE;
// 	int fpga_num_mm = MAT_M_TILE_SIZE * MAT_N_TILE_SIZE;
// 	uint64_t total_mat_ab_size 	= fpga_num_mm * mat_ab_size;
// 	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
// 	uint64_t mat_ab_offset 	= fpga_num_mm * skew_buf_size;

// 	float16_t * total_mat_a = (float16_t *)malloc(fpga_num_mm * skew_buf_size);
// 	float16_t * total_mat_b = (float16_t *)malloc(fpga_num_mm * skew_buf_size);
// 	for(int i = 0; i < fpga_num_mm; i++) {
// 		printf("a%d\n", i);
// 		memcpy((void*)(((uint64_t)total_mat_a) + i * skew_buf_size), (void*)tensor_a_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
// 		printf("b%d\n", i);
// 		memcpy((void*)(((uint64_t)total_mat_b) + i * skew_buf_size), (void*)tensor_b_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
// 		printf("done\n");
// 	}
// 	float16_t * mat_ab_buf 	= (float16_t *)malloc(2 * mat_ab_offset);
// 	float16_t * mat_ab_buf_validate 	= (float16_t *)malloc(2 * mat_ab_offset);
// 	memcpy(mat_ab_buf, total_mat_a, total_mat_ab_size);
// 	memcpy((void*)((uint64_t)mat_ab_buf + mat_ab_offset), total_mat_b, total_mat_ab_size);

// 	// write_mat_ab_all(mat_ab_buf, loops, mat_m_size);

// 	double time = fpga_gemm((float16_t *)total_mat_a, (float16_t *)total_mat_b, (float16_t *)tensor_c.data_ptr<at::Half>(), fpga_num_mm, mat_m_size, true, true);

// 	// TODO: remove these later on
// 	mat_a_addr = 0x0000;
// 	mat_b_addr = loops * mat_ab_size;
// 	mat_c_addr	= 2 * loops * mat_ab_size + 0x20000;
// 	fpga_reg_write(mat_a_addr, R_MATRIX_A_ADDR);
// 	fpga_reg_write(mat_b_addr, R_MATRIX_B_ADDR);
// 	fpga_reg_write(mat_c_addr, R_MATRIX_C_ADDR);
// 	fpga_reg_write(mat_m_size, R_MATRIX_M_SIZE);
// 	fpga_reg_write(loops, R_MATRIX_RD_CNT);

// 	// issue gemm instruction
// 	// issue_accel_instr(I_R_MAT_A, 1);
// 	usleep(1000000);
// 	for (int i = 0; i < loops/mat_m_size; i++) {

// 		// read back mat c
// 		// issue_accel_instr(I_R_MAT_C, 0);
// 		read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)tensor_c.data_ptr<at::Half>(), OUT_MATRIX_BUF_SIZE, mat_c_addr + i * OUT_MATRIX_BUF_SIZE);

// 		// print_xmatrix((float16_t *)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 		// print_xmatrix((float16_t *)tensor_c.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 		// print_xmatrix((float16_t *)tensor_c_golden.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 		print_imatrix((float16_t *)tensor_c.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 		// print_imatrix((float16_t *)tensor_c_golden.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
// 		// std::cout << "GOLDEN: " << std::endl;
// 		printf("READ ADDR: %lx\n", mat_c_addr + i * OUT_MATRIX_BUF_SIZE);
// 		// std::cout << tensor_c << std::endl;
// 		// std::cout << tensor_c_golden << std::endl;

// 		// std::cout << "tensor_c: " << std::endl;
// 		// std::cout << torch::abs(tensor_c_golden - tensor_c) << std::endl;
// 		usleep(1000000);
// 		// torch::Tensor diff = tensor_c_golden - tensor_c;
// 		// print_imatrix((float16_t *)diff.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));

// 		// std::cout << "EQ: " << std::endl;
// 		// std::cout << (tensor_c_golden - tensor_c) << std::endl;

// 		// std::cout << "GOLDEN: " << std::endl;
// 		// std::cout << torch::all(tensor_c_golden == tensor_c) << std::endl;
// 		// std::cout << (tensor_c - tensor_c_golden) << std::endl;

// 		// fpga_reg_write(I_RESET, R_ACCEL_INSTR);
// 	}
// 	clock_gettime(CLOCK_MONOTONIC_RAW, &end);
// 	uint64_t delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000;
// 	double delta_s = double(delta_us) / 1000000.0;
// 	double flops = ((double)loops * (double)MATRIX_SIZE * (double)MATRIX_SIZE * (double)MATRIX_SIZE * 2.0) / delta_s / 1000000.0;
// 	printf("FPGA Time:%f, Throughput: %f MFLOPS/s, %f MMACs/s\n", delta_s, flops, flops / 2.0);

// 	// CPU
// 	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
// 	// for (int i = 0; i < loops; i++) {
// 	// 	tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);
// 	// }
// 	torch::Tensor temp_cpu	= torch::matmul(torch::randn({MATRIX_SIZE*10, MATRIX_SIZE*10}, torch::dtype(torch::kFloat32)),
// 		 torch::randn({MATRIX_SIZE*10, MATRIX_SIZE*10}, torch::dtype(torch::kFloat32))).to(torch::kFloat16);
// 	clock_gettime(CLOCK_MONOTONIC_RAW, &end);
// 	delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000;
// 	delta_s = double(delta_us) / 1000000.0;
// 	flops = ((double)loops * (double)MATRIX_SIZE * (double)MATRIX_SIZE * (double)MATRIX_SIZE * 2.0) / delta_s / 1000000.0;
// 	printf("CPU Time:%f, Throughput: %f MFLOPS/s, %f MMACs/s\n", delta_s, flops, flops / 2.0);

// 	at::Device d(at::kCUDA);
// 	tensor_a			= torch::full({MATRIX_SIZE, MATRIX_SIZE}, -5.0, torch::dtype(torch::kFloat16)).to(d);
// 	tensor_b			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16)).to(d);

// 	// GPU
// 	clock_gettime(CLOCK_MONOTONIC_RAW, &start);
// 	// for (int i = 0; i < loops; i++) {
// 	// 	tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);
// 	// }

// 	torch::Tensor temp_gpu	= torch::matmul(torch::randn({MATRIX_SIZE*10, MATRIX_SIZE*10}, torch::dtype(torch::kFloat32)).to(d),
// 		 torch::randn({MATRIX_SIZE*10, MATRIX_SIZE*10}, torch::dtype(torch::kFloat32)).to(d)).to(torch::kFloat16);

// 	clock_gettime(CLOCK_MONOTONIC_RAW, &end);
// 	delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000;
// 	delta_s = double(delta_us) / 1000000.0;
// 	flops = ((double)loops * (double)MATRIX_SIZE * (double)MATRIX_SIZE * (double)MATRIX_SIZE * 2.0) / delta_s / 1000000.0;
// 	printf("GPU Time:%f, Throughput: %f MFLOPS/s, %f MMACs/s\n", delta_s, flops, flops / 2.0);

// 	close(fpga_w_fd);
// 	close(fpga_r_fd);
// }