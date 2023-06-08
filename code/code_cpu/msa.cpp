#include <torch/torch.h>
#include <iostream>
#include <cmath>
#include "msa.h"
#include <chrono>
#include "parallel_mm.cpp"

using namespace torch::indexing;

#define M_SIZE 32
#define TOLERANCE 1e-3


void print_tensor_info_msa(torch::Tensor tensor) {
    //std::cout << "Tensor dimension: " << tensor.dim() << std::endl;
    //std::cout << "Tensor shape: ";
    for (int64_t dim : tensor.sizes()) {
        std::cout << dim << " ";
    }
    std::cout << std::endl;
}


MSAImpl::MSAImpl(int64_t d, int64_t n_heads)
    : nheads(n_heads)
   {
    std::cout << n_heads << std::endl;
    d_head = d / n_heads;
    //#pragma omp parallel for
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      q_mappings->push_back(l);
    }
    //#pragma omp parallel for
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      k_mappings->push_back(l);
    }
    //#pragma omp parallel for
    for (int i = 0; i < n_heads; i++){
      torch::nn::Linear l(d_head, d_head);
      v_mappings->push_back(l);
    }
    register_module("q_mappings", q_mappings);
    register_module("k_mappings", k_mappings);
    register_module("v_mappings", v_mappings);
}


torch::Tensor MSAImpl::forward(torch::Tensor sequences){
  // Sequences has shape (N, l, token_dim)
  //test_process();


  const float alpha = 1.0;
  const float beta = 0.0;

  auto options = torch::TensorOptions().dtype(torch::kFloat32);
  std::vector<torch::Tensor> tensors(nheads);
  const int64_t n = sequences.size(0);
  int64_t l = sequences.size(1);
  float temp[l*l];
  
  // omp_set_num_threads(16);
  // int max_threads = omp_get_max_threads();
  // std::cout << "Maximum number of threads: " << max_threads << std::endl;

  # pragma omp parallel for schedule(static)
  for (int head = 0; head < nheads; head++){
    torch::Tensor seq = sequences.index({Slice(), Slice(), Slice(head * d_head, (head + 1) * d_head, 1)}); // (N, l, d_head)

    torch::Tensor Q, K, V;
    float *q_p, *k_p, *v_p;
    // omp_set_num_threads(3);
    #pragma omp parallel sections num_threads(3)
    {
        #pragma omp section
        {
            Q = this->q_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
            q_p = Q.data_ptr<float>();
        } 
        #pragma omp section
        {
            K = this->k_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
            k_p = K.data_ptr<float>();
        }
        #pragma omp section
        {
            V = this->v_mappings[head].get()->as<torch::nn::Linear>()->forward(seq);
            v_p = V.data_ptr<float>();
        }
    }
    

    // Iterative matmul, utilize dlp and tlp.
    float attention_ptr[n*l*d_head];

    std::vector<torch::Tensor> atts(n);

  
    // int max_threads = omp_get_max_threads();
    // std::cout << "Maximum number of threads: " << max_threads << std::endl;
# pragma omp parallel for schedule(static) private(temp)
    for (int i = 0; i < n; i++) {
      transpose_mm(q_p + (i*l*d_head), k_p + (i*l*d_head), temp, l, d_head);

      //original pytorch method to compare against
      //torch::Tensor temp_att = torch::matmul(Q.index({i, "..."}), K.index({i, "..."}).transpose(0, 1));

      torch::Tensor temp_att = torch::from_blob(temp, {l, l}, options);
      temp_att = torch::nn::functional::softmax(temp_att.div_(std::sqrt(this->d_head)),-1);
      temp_att = torch::matmul(temp_att, V.index({i, "..."}));
      atts[i] = temp_att;
    }
    torch::Tensor attention = torch::stack(atts, 0);

    // BMM Method, prob not using it anymore since we cannot optimize it.
    // torch::Tensor attention = torch::bmm(Q, K.transpose(1, 2).clone()); // (N, l, l)
    // attention = torch::bmm(torch::nn::functional::softmax(attention,1), V); // (N, l, d_head)

    //torch::Tensor attention = torch::from_blob(attention_ptr, {n, l, d_head}, options);

    tensors[head] = attention;
    // tensors.index_put_({Slice(), Slice(), Slice(head * d_head, (head+1) * d_head)}, attention);
  }
  torch::Tensor concatenated = torch::cat(tensors, 2); // (N, l, token_dim)

  return concatenated;
}
