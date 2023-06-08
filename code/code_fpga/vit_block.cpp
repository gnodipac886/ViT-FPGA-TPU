#include <torch/torch.h>
#include <iostream>
#include <cmath>
#include "vit_block.h"

void print_tensor_info_block(torch::Tensor tensor) {
    std::cout << "Tensor dimension: " << tensor.dim() << std::endl;
    std::cout << "Tensor shape: ";
    for (int64_t dim : tensor.sizes()) {
        std::cout << dim << " ";
    }
    std::cout << std::endl;
}

ViTBlockImpl::ViTBlockImpl(int64_t hidden_d, int64_t n_heads, int64_t mlp_ratio): 
    norm1(torch::nn::LayerNormOptions({hidden_d})),
    norm2(torch::nn::LayerNormOptions({hidden_d})),
    fc1(hidden_d, mlp_ratio * hidden_d),
    g1(),
    fc2(mlp_ratio * hidden_d, hidden_d),
    hidden_d(hidden_d),
    n_heads(n_heads)
{
    mhsa = MSA(hidden_d, n_heads);
    register_module("norm1", norm1);
    register_module("norm2", norm2);
    register_module("fc1", fc1);
    register_module("g1", g1);
    register_module("fc2", fc2);
    register_module("mhsa", mhsa);
}

torch::Tensor ViTBlockImpl::forward(torch::Tensor x){
    torch::Tensor out = x + mhsa->forward(norm1->forward(x));
    out = out + fc2->forward(g1->forward(fc1->forward((norm2->forward(out)))));
    return out;
}
