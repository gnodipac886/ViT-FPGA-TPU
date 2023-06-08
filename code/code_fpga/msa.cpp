#include <torch/torch.h>
#include <iostream>
#include <cmath>
#include "msa.h"
#include <chrono>
#include "parallel_mm.cpp"
#include "fpga.h"
//#include "accel_driver/include/matrix_utils.h"

using namespace torch::indexing;

#define M_SIZE 16
#define TOLERANCE 1e-3

#include <torch/torch.h>

bool are_tensors_close(torch::Tensor tensor1, torch::Tensor tensor2) {
    // Compute the element-wise absolute difference between the two tensors
    torch::Tensor diff = torch::abs(tensor1 - tensor2);
    
    // Compute the maximum absolute difference between the two tensors
    float max_diff = diff.max().item<float>();
    
    // Compare the maximum absolute difference with the tolerance level
    if (max_diff < TOLERANCE) {
        return true;
    } else {
        return false;
    }
}

float tensor_l2_norm(const at::Tensor& tensor1, const at::Tensor& tensor2) {
  auto sizes = tensor1.sizes();
    int m = sizes[0];
    int n = sizes[1];
    auto diff = tensor1 - tensor2;
    auto l2_norm = at::norm(diff, 2);
    return l2_norm.item<float>() / (m*n);
}


void print_tensor_info_msa(torch::Tensor tensor) {
    //std::cout << "Tensor dimension: " << tensor.dim() << std::endl;
    //std::cout << "Tensor shape: ";
    for (int64_t dim : tensor.sizes()) {
        std::cout << dim << " ";
    }
    std::cout << std::endl;
}

torch::Tensor pad_tensor(torch::Tensor input) {
    // Get the current size of the tensor
    auto sizes = input.sizes();
    int m = sizes[0];
    int n = sizes[1];

    int m_pad = (m%M_SIZE == 0) ? 0 : (M_SIZE - m % M_SIZE);
    //std::cout << m_pad << std::endl;
    int n_pad = (n%M_SIZE == 0) ? 0 : (M_SIZE - n % M_SIZE);
    //std::cout << n_pad << std::endl;

    // Calculate the new sizes after padding
    int new_m = m + m_pad;
    int new_n = n + n_pad;

    // Create a new tensor with the padded sizes
    torch::Tensor output = torch::zeros({new_m, new_n}).to(torch::kFloat16);

    // Copy the input tensor into the new tensor, leaving the padded regions as zeros
    output.slice(0, 0, m)
          .slice(1, 0, n)
          .copy_(input);

    return output;
}

torch::Tensor unpad_tensor(torch::Tensor input, int original_m, int original_n) {
    // Get the current size of the tensor
    auto sizes = input.sizes();
    int m = sizes[0];
    int n = sizes[1];

    // Calculate the padding that was applied to the original tensor
    int m_pad = m - original_m;
    int n_pad = n - original_n;

    // Create a slice that only includes the original region of the padded tensor
    auto original_slice = input.slice(0, 0, original_m).slice(1, 0, original_n);

    // Return a new tensor that only includes the original region of the padded tensor
    return original_slice.clone();
}

torch::Tensor _processV(torch::Tensor matrix) { // size = (32g, 32h)
    // const int64_t n = matrix.size(0);
    // int64_t m = matrix.size(1);
    // int64_t g = n / M_SIZE;
    // int64_t h = m / M_SIZE;
    // torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    // //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    // //torch::Tensor out = matrix;
    // out = out.permute({1, 0, 2, 3}).reshape({-1, M_SIZE, M_SIZE});

    // out = out.repeat({h, 1, 1}).reshape({-1});

    // //print_imatrix(matrix.data_ptr<at::Half>(), 32, 32, sizeof(float16_t));

    // //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    // float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    // //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    // //float16_t result[n * 3 * h];
    // // torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    // torch::Tensor result = torch::zeros({h*g*h, M_SIZE*(2*M_SIZE-1)}).to(torch::kFloat16);

    // int j = 0;
    // for (int i = 0; i < h* n * m; i += M_SIZE*M_SIZE){
    //   skew_matrix((float16_t*)(result.data_ptr<at::Half>() + j), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

    //   //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
    //   //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

    //   //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
    //   //std::cout << i << std::endl;
    //   //std::cout << "---------------------------------------------------------" << std::endl;
    //   j += M_SIZE*(2*M_SIZE-1); 
    // }
    // auto options = torch::TensorOptions().dtype(torch::kFloat16);

    const int64_t n = matrix.size(0);
    int64_t m = matrix.size(1);
    int64_t g = n / M_SIZE;
    int64_t h = m / M_SIZE;
    torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    //print_imatrix((float16_t *)out.data_ptr<at::Half>(), 4, 6, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));
    out = out.permute({1, 0, 2, 3}).reshape({-1, M_SIZE, M_SIZE});


    // out = out.repeat({h, 1, 1});
    out = at::transpose_copy(out, 1, 2).repeat({g, 1, 1});

    //print_imatrix(matrix.data_ptr<at::Half>(), 32, 32, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    //float16_t result[n * 3 * h];
    //torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    torch::Tensor result = torch::zeros({g*g*h*2*M_SIZE, M_SIZE}).to(torch::kFloat16);


    int j = 0;
    int k = 0;
    for (int i = 0; i < g* n * m; i += M_SIZE*M_SIZE){
      torch::Tensor temp = torch::zeros({M_SIZE, (2*M_SIZE-1)}, torch::dtype(torch::kFloat16));
      skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i*M_SIZE, M_SIZE], M_SIZE, M_SIZE, sizeof(float16_t));
      torch::Tensor temp2 = at::transpose_copy(temp, 0, 1);
      //std::cout << temp2 << std::endl;
      memcpy((void*)(((uint64_t)result.data_ptr<at::Half>()) + k), (void*)temp2.data_ptr<at::Half>(), 2* M_SIZE* (2*M_SIZE-1));

      //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
      //std::cout << i << std::endl;
      //std::cout << "---------------------------------------------------------" << std::endl;
      k += M_SIZE * M_SIZE * 2 * 2;
      j += M_SIZE*(2*M_SIZE-1); 
    }
    // for (int i = 0; i < n*3*h; i++){
    //   std::cout << (float)result[i] << " ";
    // }
    return result;
    //return torch::from_blob(result, {n, 3 * h}, options);
    //std::cout << "3" << std::endl;
}

torch::Tensor _processA(torch::Tensor matrix) { // size = (32g, 32h)
    // const int64_t n = matrix.size(0);
    // int64_t m = matrix.size(1);
    // int64_t g = n / M_SIZE;
    // int64_t h = m / M_SIZE;
    // torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    // //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    // //torch::Tensor out = matrix;
    // out = out.permute({1, 0, 2, 3}).reshape({-1, M_SIZE, M_SIZE});

    // out = out.repeat({h, 1, 1}).reshape({-1});

    // //print_imatrix(matrix.data_ptr<at::Half>(), 32, 32, sizeof(float16_t));

    // //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    // float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    // //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    // //float16_t result[n * 3 * h];
    // // torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    // torch::Tensor result = torch::zeros({h*g*h, M_SIZE*(2*M_SIZE-1)}).to(torch::kFloat16);

    // int j = 0;
    // for (int i = 0; i < h* n * m; i += M_SIZE*M_SIZE){
    //   skew_matrix((float16_t*)(result.data_ptr<at::Half>() + j), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

    //   //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
    //   //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

    //   //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
    //   //std::cout << i << std::endl;
    //   //std::cout << "---------------------------------------------------------" << std::endl;
    //   j += M_SIZE*(2*M_SIZE-1); 
    // }
    // auto options = torch::TensorOptions().dtype(torch::kFloat16);

    const int64_t n = matrix.size(0);
    int64_t m = matrix.size(1);
    int64_t g = n / M_SIZE;
    int64_t h = m / M_SIZE;
    torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    //print_imatrix((float16_t *)out.data_ptr<at::Half>(), 4, 6, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));
    out = out.permute({1, 0, 2, 3}).reshape({-1, M_SIZE, M_SIZE});


    // out = out.repeat({h, 1, 1});
    out = at::transpose_copy(out, 1, 2).repeat({h, 1, 1});

    //print_imatrix(matrix.data_ptr<at::Half>(), 32, 32, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    //float16_t result[n * 3 * h];
    //torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    torch::Tensor result = torch::zeros({h*g*h*2*M_SIZE, M_SIZE}).to(torch::kFloat16);


    int j = 0;
    int k = 0;
    for (int i = 0; i < h* n * m; i += M_SIZE*M_SIZE){
      torch::Tensor temp = torch::zeros({M_SIZE, (2*M_SIZE-1)}, torch::dtype(torch::kFloat16));
      skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i*M_SIZE, M_SIZE], M_SIZE, M_SIZE, sizeof(float16_t));
      torch::Tensor temp2 = at::transpose_copy(temp, 0, 1);
      //std::cout << temp2 << std::endl;
      memcpy((void*)(((uint64_t)result.data_ptr<at::Half>()) + k), (void*)temp2.data_ptr<at::Half>(), 2* M_SIZE* (2*M_SIZE-1));

      //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
      //std::cout << i << std::endl;
      //std::cout << "---------------------------------------------------------" << std::endl;
      k += M_SIZE * M_SIZE * 2 * 2;
      j += M_SIZE*(2*M_SIZE-1); 
    }
    // for (int i = 0; i < n*3*h; i++){
    //   std::cout << (float)result[i] << " ";
    // }
    return result;
    //return torch::from_blob(result, {n, 3 * h}, options);
    //std::cout << "3" << std::endl;
}



torch::Tensor _processB(torch::Tensor matrix) {
    const int64_t n = matrix.size(0);
    int64_t m = matrix.size(1);
    int64_t g = n / M_SIZE;
    int64_t h = m / M_SIZE;
    torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    //print_imatrix((float16_t *)out.data_ptr<at::Half>(), 4, 6, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));
    out = out.unsqueeze(1).repeat({1, g, 1, 1, 1}).reshape({-1, M_SIZE, M_SIZE});

    //print_imatrix((float16_t *)out.data_ptr<at::Half>(), 8, 6, sizeof(float16_t));

    //torch::Tensor out = matrix;
    out = out.reshape({-1}).clone();

    //print_imatrix(matrix.data_ptr<at::Half>(), 32, 32, sizeof(float16_t));

    //print_imatrix(out.data_ptr<at::Half>(), 8, 8, sizeof(float16_t));

    float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    //float16_t result[n * 3 * h];
    //torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    torch::Tensor result = torch::zeros({g*g*h*2*M_SIZE, M_SIZE}).to(torch::kFloat16);

    int j = 0;
    int k = 0;
    for (int i = 0; i < g* n * m; i += M_SIZE*M_SIZE){
      torch::Tensor temp = torch::zeros({M_SIZE, (2*M_SIZE-1)}, torch::dtype(torch::kFloat16));
      // skew_matrix((float16_t*)(result.data_ptr<at::Half>() + j), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      torch::Tensor temp2 = at::transpose_copy(temp, 0, 1);
      //std::cout << temp2 << std::endl;
      memcpy((void*)(((uint64_t)result.data_ptr<at::Half>()) + k), (void*)temp2.data_ptr<at::Half>(), 2* M_SIZE* (2*M_SIZE-1));

      //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
      //std::cout << i << std::endl;
      //std::cout << "---------------------------------------------------------" << std::endl;
      k += M_SIZE * M_SIZE * 2 * 2;
      j += M_SIZE*(2*M_SIZE-1); 
    }
    //auto options = torch::TensorOptions().dtype(torch::kFloat16);
    // for (int i = 0; i < n*3*h; i++){
    //   std::cout << (float)result[i] << " ";
    // }
    return result;
    //return torch::from_blob(result, {n, 3 * h}, options);
    //std::cout << "3" << std::endl;
}

torch::Tensor _processC(torch::Tensor matrix) { // size = (32g, 32h)
    const int64_t n = matrix.size(0);
    int64_t m = matrix.size(1);
    int64_t g = n / M_SIZE;
    int64_t h = m / M_SIZE;
    torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    out = out.permute({1, 0, 2, 3}).reshape({-1, M_SIZE, M_SIZE});

    out = out.repeat({4, 1, 1}).transpose(2,1).reshape({-1}).clone();


    float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    //float16_t result[n * 3 * h];
    //torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    torch::Tensor result = torch::zeros({g*g*h*2*M_SIZE, M_SIZE}).to(torch::kFloat16);

    int k = 0;
    for (int i = 0; i < g* n * m; i += M_SIZE*M_SIZE){
      torch::Tensor temp = torch::zeros({M_SIZE, (2*M_SIZE-1)}, torch::dtype(torch::kFloat16));
      // skew_matrix((float16_t*)(result.data_ptr<at::Half>() + j), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      torch::Tensor temp2 = at::transpose_copy(temp, 0, 1);
      //std::cout << temp2 << std::endl;
      memcpy((void*)(((uint64_t)result.data_ptr<at::Half>()) + k), (void*)temp2.data_ptr<at::Half>(), 2* M_SIZE* (2*M_SIZE-1));

      //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
      //std::cout << i << std::endl;
      //std::cout << "---------------------------------------------------------" << std::endl;
      k += M_SIZE * M_SIZE * 2 * 2;
    }

    return result;
}

torch::Tensor _process_new_A(torch::Tensor matrix) { // size = (32g, 32h)
    const int64_t n = matrix.size(0);
    int64_t m = matrix.size(1);
    int64_t g = n / M_SIZE;
    int64_t h = m / M_SIZE;
    torch::Tensor out = matrix.unfold(0, M_SIZE, M_SIZE).unfold(1, M_SIZE, M_SIZE);

    out = out.reshape({-1}).clone();

    float16_t *out_ptr = (float16_t*)out.data_ptr<at::Half>();
    //print_imatrix(out_ptr, 4, 4, sizeof(float16_t));
    //float16_t result[n * 3 * h];
    //torch::Tensor result = torch::zeros({n, (2*M_SIZE-1)*h}).to(torch::kFloat16);
    torch::Tensor result = torch::zeros({g*h*2*M_SIZE, M_SIZE}).to(torch::kFloat16);

    int k = 0;
    for (int i = 0; i < n * m; i += M_SIZE*M_SIZE){
      torch::Tensor temp = torch::zeros({M_SIZE, (2*M_SIZE-1)}, torch::dtype(torch::kFloat16));
      // skew_matrix((float16_t*)(result.data_ptr<at::Half>() + j), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));
      torch::Tensor temp2 = at::transpose_copy(temp, 0, 1);
      //std::cout << temp2 << std::endl;
      memcpy((void*)(((uint64_t)result.data_ptr<at::Half>()) + k), (void*)temp2.data_ptr<at::Half>(), 2* M_SIZE* (2*M_SIZE-1));

      //torch::Tensor temp = torch::zeros({M_SIZE, 2*M_SIZE-1}).to(torch::kFloat16);
      //skew_matrix((float16_t*)(temp.data_ptr<at::Half>()), &out_ptr[i], M_SIZE, M_SIZE, sizeof(float16_t));

      //print_imatrix(temp.data_ptr<at::Half>(), M_SIZE, 2*M_SIZE-1, sizeof(float16_t));
      //std::cout << i << std::endl;
      //std::cout << "---------------------------------------------------------" << std::endl;
      k += M_SIZE * M_SIZE * 2 * 2;
    }

    return result;
}

void test_mm_main(){

	int MAT_M_TILE_SIZE = 1;
	int MAT_N_TILE_SIZE = 1;
	int MAT_M_SIZE = MATRIX_SIZE * MAT_M_TILE_SIZE;
	int MAT_N_SIZE = MATRIX_SIZE * MAT_N_TILE_SIZE;
	int fpga_num_mm = MAT_M_TILE_SIZE * MAT_M_TILE_SIZE * MAT_N_TILE_SIZE;
	int mat_m_size = MAT_N_TILE_SIZE;
	uint64_t skew_buf_size = MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);

	torch::Tensor tensor_a			= torch::ones({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
	// set_row_col_consecutive((float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE);
	std::cout << tensor_a << std::endl;

	// torch::Tensor tensor_a			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16)) * -6.6;
	torch::Tensor tensor_a_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_a_skew_T;
	// torch::Tensor tensor_b			= torch::eye(MATRIX_SIZE, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b			= torch::ones({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b_skew		= torch::zeros({MATRIX_SIZE, SKEW_MAT_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_b_skew_T;
	torch::Tensor tensor_c			= torch::zeros({MATRIX_SIZE, MATRIX_SIZE}, torch::dtype(torch::kFloat16));
	torch::Tensor tensor_c_golden	= torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)).to(torch::kFloat16);

	// std::cout << "Golden Matrix: " << std::endl;
	// print_imatrix((float16_t *)tensor_c_golden.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));

	// std::cout << tensor_a << std::endl;
	skew_matrix((float16_t*)tensor_a_skew.data_ptr<at::Half>(), (float16_t*)tensor_a.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
	skew_matrix((float16_t*)tensor_b_skew.data_ptr<at::Half>(), (float16_t*)tensor_b.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));
	// tensor_a_skew_T = at::transpose_copy(tensor_a_skew, 0, 1);

  print_imatrix((float16_t *)tensor_a_skew.data_ptr<at::Half>(), MATRIX_SIZE, 31, sizeof(float16_t));
  print_imatrix((float16_t *)tensor_b_skew.data_ptr<at::Half>(), MATRIX_SIZE, 31, sizeof(float16_t));

  tensor_a_skew_T = tensor_a_skew.clone();
	tensor_b_skew_T = at::transpose_copy(tensor_b_skew, 0, 1);

  print_imatrix((float16_t *)tensor_b_skew_T.data_ptr<at::Half>(), 31, MATRIX_SIZE, sizeof(float16_t));

	float16_t * total_mat_a = (float16_t *)malloc(fpga_num_mm * skew_buf_size);
	float16_t * total_mat_b = (float16_t *)malloc(fpga_num_mm * skew_buf_size);
	for(int i = 0; i < fpga_num_mm; i++) {
		printf("a%d\n", i);
		memcpy((void*)(((uint64_t)total_mat_a) + i * skew_buf_size), (void*)tensor_a_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
		printf("b%d\n", i);
		memcpy((void*)(((uint64_t)total_mat_b) + i * skew_buf_size), (void*)tensor_b_skew_T.data_ptr<at::Half>(), IN_SKEW_BUF_SIZE);
		printf("done\n");
	}
	// print_imatrix((float16_t *)total_mat_b, MATRIX_SIZE * fpga_num_mm * 2, MATRIX_SIZE, sizeof(float16_t));

	fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

	double time = fpga_gemm((float16_t *)total_mat_a, (float16_t *)total_mat_b, (float16_t *)tensor_c.data_ptr<at::Half>(), fpga_num_mm, mat_m_size, true, true);
	std::cout << "TIME SPENT: " << time << std::endl;
  //std::cout << torch::matmul(tensor_a.to(torch::kFloat32), tensor_b.to(torch::kFloat32)) << std::endl;
	//print_imatrix((float16_t *)tensor_c.data_ptr<at::Half>(), MATRIX_SIZE, MATRIX_SIZE, sizeof(float16_t));

	close(fpga_w_fd);
	close(fpga_r_fd);
	free(total_mat_a);
	free(total_mat_b);
}



torch::Tensor test_rand_mm_fpga(){
  torch::Tensor tensor1 = (torch::rand({50, 1*M_SIZE})*-0.3).to(torch::kFloat16);
  // //print_imatrix(tensor1.data_ptr<at::Half>(), 64,14, sizeof(float16_t));
  torch::Tensor tensor2 = torch::rand({1*M_SIZE, 50}).to(torch::kFloat16);
  // std::cout << tensor1 << std::endl;
  // std::cout << tensor2 << std::endl;

  //print_imatrix(tensor1.data_ptr<at::Half>(), 50, 16, sizeof(float16_t));
  //print_imatrix(tensor2.data_ptr<at::Half>(), 16, 50, sizeof(float16_t));
  
  //torch::Tensor tensor2 = tensor1.clone().transpose(0,1);

  tensor1 = pad_tensor(tensor1.to(torch::kFloat16));
  tensor2 = pad_tensor(tensor2.to(torch::kFloat16));

  torch::Tensor out3 = torch::zeros({4*M_SIZE, 4*M_SIZE}).to(torch::kFloat16);

  //float16_t *outt = new float16_t[16*16];
  auto options = torch::TensorOptions().dtype(torch::kFloat16);

  torch::Tensor out1 = _processB(tensor1);
  //print_imatrix(out1.data_ptr<at::Half>(), 32, 16, sizeof(float16_t));
  torch::Tensor out2 = _processA(tensor2);
  //print_imatrix(out2.data_ptr<at::Half>(), 32, 16, sizeof(float16_t));

  fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

  //print_imatrix((float16_t *)out1.data_ptr<at::Half>(), 84, 4, sizeof(float16_t));
  //print_imatrix((float16_t *)out2.data_ptr<at::Half>(), 3*12, 2, sizeof(float16_t));

	fpga_gemm((float16_t *)out1.data_ptr<at::Half>(), (float16_t *)out2.data_ptr<at::Half>(), (float16_t *)out3.data_ptr<at::Half>(), 16, 1, true, true);
	//std::cout << "TIME SPENT: " << time << std::endl;

  close(fpga_w_fd);
	close(fpga_r_fd);

  // std::cout << out3 << std::endl;
  print_imatrix(out3.data_ptr<at::Half>(), 64,64, sizeof(float16_t));
  print_imatrix(tensor1.data_ptr<at::Half>(), 64,14, sizeof(float16_t));
  std::cout << tensor1.to(torch::kFloat32) << std::endl;
  std::cout << torch::matmul(tensor1.to(torch::kFloat32),tensor2.to(torch::kFloat32)) << std::endl;
  return out3;
  //std::cout << are_tensors_close(out3, torch::matmul(tensor1.to(torch::kFloat32),tensor2.to(torch::kFloat32))) << std::endl; 
}

torch::Tensor test_mm_fpga(torch::Tensor tensor1, torch::Tensor tensor2){
  tensor1 = tensor1.to(torch::kFloat16);
  tensor2 = tensor2.to(torch::kFloat16);
  // std::cout << tensor1 << std::endl;
  // std::cout << tensor2 << std::endl;

  print_imatrix(tensor1.data_ptr<at::Half>(), 50, 16, sizeof(float16_t));
  print_imatrix(tensor2.data_ptr<at::Half>(), 16, 50, sizeof(float16_t));

  tensor1 = pad_tensor(tensor1.to(torch::kFloat16));
  tensor2 = pad_tensor(tensor2.to(torch::kFloat16));

  torch::Tensor out3 = torch::zeros({4*M_SIZE, 4*M_SIZE}).to(torch::kFloat16);

  //float16_t *outt = new float16_t[16*16];
  auto options = torch::TensorOptions().dtype(torch::kFloat16);

  torch::Tensor out1 = _processB(tensor1);
  //print_imatrix(out1.data_ptr<at::Half>(), 32, 16, sizeof(float16_t));
  torch::Tensor out2 = _processA(tensor2);
  //print_imatrix(out2.data_ptr<at::Half>(), 32, 16, sizeof(float16_t));

  //print_imatrix((float16_t *)out1.data_ptr<at::Half>(), 84, 4, sizeof(float16_t));
  //print_imatrix((float16_t *)out2.data_ptr<at::Half>(), 3*12, 2, sizeof(float16_t));

	fpga_gemm((float16_t *)out1.data_ptr<at::Half>(), (float16_t *)out2.data_ptr<at::Half>(), (float16_t *)out3.data_ptr<at::Half>(), 16, 1, true, true);
	//std::cout << "TIME SPENT: " << time << std::endl;

  // std::cout << out3 << std::endl;
  print_imatrix(out3.data_ptr<at::Half>(), 64,64, sizeof(float16_t));
  // print_imatrix(tensor1.data_ptr<at::Half>(), 64,14, sizeof(float16_t));
  // std::cout << tensor1.to(torch::kFloat32) << std::endl;
  // std::cout << torch::matmul(tensor1.to(torch::kFloat32),tensor2.to(torch::kFloat32)) << std::endl;
  return out3;
  //std::cout << are_tensors_close(out3, torch::matmul(tensor1.to(torch::kFloat32),tensor2.to(torch::kFloat32))) << std::endl; 
}


MSAImpl::MSAImpl(int64_t d, int64_t n_heads)
    : nheads(n_heads)
   {
    d_head = d / n_heads;
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      torch::nn::init::xavier_uniform_(l->weight);
      q_mappings->push_back(l);
    }
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      torch::nn::init::xavier_uniform_(l->weight);
      k_mappings->push_back(l);
    }
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      torch::nn::init::xavier_uniform_(l->weight);
      v_mappings->push_back(l);
    }
    register_module("q_mappings", q_mappings);
    register_module("k_mappings", k_mappings);
    register_module("v_mappings", v_mappings);
}

float16_t * mat_a_buf,  mat_b_buf;
uint32_t fpga_num_mm = 16;
uint32_t mat_m_size = 1;
uint64_t total_mat_ab_size 	= fpga_num_mm * mat_ab_size;
uint64_t mat_ab_offset 		= fpga_num_mm * MATRIX_SIZE * MATRIX_SIZE * 2 * sizeof(float16_t);
uint64_t mat_c_size 		= (fpga_num_mm / mat_m_size) * OUT_MATRIX_BUF_SIZE;
float16_t * mat_ab_buf 		= (float16_t *)malloc(2 * mat_ab_offset);

torch::Tensor MSAImpl::forward(torch::Tensor sequences){

  // fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	// fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

  // Sequences has shape (N, l, token_dim)
  //test_process();
  // test_mm_main();
  // test_rand_mm_fpga();
  // exit(0);

  auto options = torch::TensorOptions().dtype(torch::kFloat32);
  std::vector<torch::Tensor> tensors(nheads);
  const int64_t n = sequences.size(0);
  int64_t l = sequences.size(1);
  float temp[l*l];
  // std::cout << "seq length: " << l << std::endl;
  // torch::Tensor tensors = torch::zeros_like(sequences);
  for (int head = 0; head < this->nheads; head++){
    torch::Tensor seq = sequences.index({Slice(), Slice(), Slice(head * d_head, (head + 1) * d_head, 1)}); // (N, l, d_head)
    //std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

    torch::Tensor Q, K, V;
    float *q_p, *k_p, *v_p;
    #pragma omp parallel num_threads(3)
    {
        #pragma omp for nowait
        for (int i = 0; i < 3; ++i) {
            if (i == 0) {
                Q = this->q_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
                Q = Q.div_(std::sqrt(this->d_head));
                q_p = Q.data_ptr<float>();
            } else if (i == 1) {
                K = this->k_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
                k_p = K.data_ptr<float>();
            } else {
                V = this->v_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
                v_p = V.data_ptr<float>();
            }
        }
    }
    float attention_ptr[n*l*d_head];

    std::vector<torch::Tensor> atts(n);
    for (int i = 0; i < n; i++) {
      // Matmul Q and K.T
      torch::Tensor Q_pad;
      torch::Tensor K_pad;
      torch::Tensor V_pad;

      mat_a_addr = 0x0;
      mat_b_addr = mat_a_addr + total_mat_ab_size;
      mat_c_addr = mat_b_addr + total_mat_ab_size;
      mat_d_addr = mat_c_addr + 16 * total_mat_ab_size;

      torch::Tensor temp_att = torch::zeros({64, 64}).to(torch::kFloat16);
      torch::Tensor final_out = torch::zeros({64, 16}).to(torch::kFloat16);

      fpga_w_fd = open(WRITE_DEV_NAME, O_RDWR);
	    fpga_r_fd = open(READ_DEV_NAME, O_RDWR);

      // MM START!! --------------------------------------------------------------------

      // #pragma omp parallel num_threads(2)
      // {
      //       // Perform a write operation in a separate thread
      //       #pragma omp single nowait
      //       {
      //           V_pad = pad_tensor(V.index({i, "..."}));
      //           V_pad = _processC(V_pad);
      //           // write matrix C into FPGA
      //           write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)V_pad.data_ptr<at::Half>(), mat_ab_offset, mat_d_addr);
      //       }
      //       // Spawn another thread to do other stuff
      //       #pragma omp single
      //       {
      //           Q_pad = pad_tensor(Q.index({i, "..."}));
      //           K_pad = pad_tensor(K.index({i, "..."}).transpose(0, 1));
      //           Q_pad = _processB(Q_pad);  // (4 * 4 , 64 , 32)
      //           K_pad = _processA(K_pad);
      //           // make a single big buffer to hold both
	    //           float16_t * mat_ab_buf 		= (float16_t *)malloc(2 * mat_ab_offset);

      //           memcpy(mat_ab_buf, (float16_t *)Q_pad.data_ptr<at::Half>(), mat_ab_offset);
      //           memcpy((void*)((uint64_t)mat_ab_buf + mat_ab_offset), (float16_t *)K_pad.data_ptr<at::Half>(), mat_ab_offset);
      //       }
      //       #pragma omp taskwait
      // }

      // V_pad = pad_tensor(V.index({i, "..."}));
      
      // V_pad = _processV(V_pad);
      // write matrix C into FPGA
      // write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)V_pad.data_ptr<at::Half>(), mat_ab_offset, mat_d_addr);

      Q_pad = pad_tensor(Q.index({i, "..."}));
      K_pad = pad_tensor(K.index({i, "..."}).transpose(0,1));
      Q_pad = _processB(Q_pad);  // (4 * 4 , 64 , 32)
      K_pad = _processA(K_pad);

      // make a single big buffer to hold both
      float16_t * mat_ab_buf 		= (float16_t *)malloc(2 * mat_ab_offset);

      memcpy(mat_ab_buf, (float16_t *)Q_pad.data_ptr<at::Half>(), mat_ab_offset);
      memcpy((void*)((uint64_t)mat_ab_buf + mat_ab_offset), (float16_t *)K_pad.data_ptr<at::Half>(), mat_ab_offset);

      // write matrix A and B into FPGA
      //std::chrono::steady_clock::time_point  begin = std::chrono::steady_clock::now();
      write_mat_ab_all(mat_ab_buf, fpga_num_mm, mat_m_size);
      //std::chrono::steady_clock::time_point  end = std::chrono::steady_clock::now();
      //std::cout << "Time difference (write ab all) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;



      // do GEMM
       //begin = std::chrono::steady_clock::now();
      issue_accel_instr(I_R_MAT_A, 0); // 0 for non blocking
       //end = std::chrono::steady_clock::now();
      //std::cout << "Time difference (matmul ab) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

      fpga_num_mm = 16; //4*4 times 4*1, still 16 block of gemms
      mat_m_size = 4; //4*4 times 4*1, each time we accumulate results from 4 consecutive blocks
      mat_a_addr = 0x0;
      mat_d_addr = mat_a_addr + total_mat_ab_size;
      mat_c_addr = mat_b_addr + total_mat_ab_size;


      V_pad = pad_tensor(V.index({i, "..."}));
       //begin = std::chrono::steady_clock::now();
      V_pad = _processV(V_pad);
      //end = std::chrono::steady_clock::now();
      //std::cout << "Time difference (process V) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
       //begin = std::chrono::steady_clock::now();
      write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)V_pad.data_ptr<at::Half>(), mat_ab_offset, mat_d_addr);
      /// end = std::chrono::steady_clock::now();
      //std::cout << "Time difference (send V) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

      matmul_sync(); // we wait for the prev matmul here

      // read back matrix A*B
      float16_t * temp_holder = (float16_t *)malloc(16*OUT_MATRIX_BUF_SIZE);
      read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)temp_holder, 16*OUT_MATRIX_BUF_SIZE, mat_c_addr);
      

      for (int i = 0; i < 4; i++){
        for (int j = 0; j < 4; j++){
          torch::Tensor temp_mat_holder = torch::zeros({M_SIZE, M_SIZE}).to(torch::kFloat16);
          memcpy((float16_t *)temp_mat_holder.data_ptr<at::Half>(), &temp_holder[(i*4+j) * M_SIZE * M_SIZE], OUT_MATRIX_BUF_SIZE);
          //std::cout << temp_mat_holder << std::endl;
          //std::cout << temp_att << std::endl;
          std::vector<torch::indexing::TensorIndex> indices = {
              torch::indexing::Slice(i*M_SIZE, i*M_SIZE+M_SIZE),
              torch::indexing::Slice(j*M_SIZE, j*M_SIZE+M_SIZE)
          };
          temp_att.index_put_(indices, temp_mat_holder);
          //temp_att.slice(i*M_SIZE, (i+1)*M_SIZE).slice(j*M_SIZE, (j+1)*M_SIZE) = temp_mat_holder;
        }
      }

      // write matrix C addr into FPGA reg
      fpga_num_mm = 16; //4*4 times 4*1, still 16 block of gemms
      mat_m_size = 4; //4*4 times 4*1, each time we accumulate results from 4 consecutive blocks
      mat_a_addr = 0x0;
      mat_d_addr = mat_a_addr + total_mat_ab_size;
      mat_c_addr = mat_b_addr + total_mat_ab_size;
      // mat_a_addr = 0x0;
      // mat_b_addr = mat_a_addr + total_mat_ab_size;
      // mat_c_addr = mat_b_addr + total_mat_ab_size;
      // mat_d_addr = mat_c_addr + 16 * total_mat_ab_size;
      fpga_reg_write(mat_d_addr, R_MATRIX_B_ADDR); //matrix B is gonna be at mat_d_addr
      fpga_reg_write(mat_c_addr, R_MATRIX_C_ADDR);
      fpga_reg_write(fpga_num_mm, R_MATRIX_RD_CNT);
      fpga_reg_write(mat_m_size, R_MATRIX_M_SIZE);

      // std::cout << temp_att.to(torch::kFloat16) << std::endl;
      // std::cout << (torch::matmul(Q.index({i, "..."}), K.index({i, "..."}).transpose(0,1))) << std::endl;
      temp_att = _process_new_A(torch::nn::functional::softmax(temp_att.to(torch::kFloat32), 1).to(torch::kFloat16));

      // write back matrix A*B
      // std::cout << V_pad << std::endl;
      // print_imatrix(V_pad.data_ptr<at::Half>(), 512, 16, 2);
      // exit(0);
      write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)temp_att.data_ptr<at::Half>(), mat_ab_offset, mat_a_addr);
      // write_from_buffer(WRITE_DEV_NAME, fpga_w_fd, (char *)V_pad.data_ptr<at::Half>(), mat_ab_offset, mat_d_addr);
      //printf("%x mat_d_addr\n", mat_d_addr);
      fpga_reg_write(mat_a_addr, R_MATRIX_A_ADDR);

      // do GEMM
      issue_accel_instr(I_R_MAT_A, 1); // 1 for blocking

      // read back matrix (A*B) * C
      float16_t* temp_holder_2 = (float16_t *)malloc(4 * OUT_MATRIX_BUF_SIZE);

      torch::Tensor temp_holder_3 = torch::zeros({64, 16}).to(torch::kFloat16);
      read_to_buffer(READ_DEV_NAME, fpga_r_fd, (char *)temp_holder_2, 4*OUT_MATRIX_BUF_SIZE, mat_c_addr);

      for (int i = 0; i < 1; i++){
        for (int j = 0; j < 4; j++){
          torch::Tensor temp_mat_holder = torch::zeros({M_SIZE, M_SIZE}).to(torch::kFloat16);
          memcpy((float16_t *)temp_mat_holder.data_ptr<at::Half>(), &temp_holder_2[(i*4+j) * M_SIZE * M_SIZE], OUT_MATRIX_BUF_SIZE);

          std::vector<torch::indexing::TensorIndex> indices = {
              torch::indexing::Slice(j*M_SIZE, j*M_SIZE+M_SIZE),
              torch::indexing::Slice(i*M_SIZE, i*M_SIZE+M_SIZE)
          };
          final_out.index_put_(indices, temp_mat_holder);
        }
      }

      close(fpga_w_fd);
	    close(fpga_r_fd);
      final_out = unpad_tensor(final_out, 50, 16).to(torch::kFloat32);

      //std::cout << "mean L2 norm: " << tensor_l2_norm(final_out, torch::matmul(torch::nn::functional::softmax(torch::matmul(Q.index({i, "..."}), K.index({i, "..."}).transpose(0,1)),1 ), V.index({i, "..."}))) << std::endl;
      // show_tensor_l2_norm(final_out, torch::matmul(torch::nn::functional::softmax(torch::matmul(Q.index({i, "..."}), K.index({i, "..."}).transpose(0,1)),1 ), V.index({i, "..."})));
      //std::cout << final_out << std::endl;
      //std::cout <<  torch::matmul(torch::nn::functional::softmax(torch::matmul(Q.index({i, "..."}), K.index({i, "..."}).transpose(0,1)),1 ), V.index({i, "..."})) << std::endl;

      atts[i] = final_out;
    }
    torch::Tensor attention = torch::stack(atts, 0);

    tensors[head] = attention;
  }
  torch::Tensor concatenated = torch::cat(tensors, 2); // (N, l, token_dim)
  return concatenated;
}
