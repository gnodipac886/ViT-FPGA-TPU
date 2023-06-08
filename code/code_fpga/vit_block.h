#pragma once

#include <torch/torch.h>
#include "msa.h"

class ViTBlockImpl : public torch::nn::Module {
    public:
        ViTBlockImpl(int64_t hidden_d, int64_t n_heads, int64_t mlp_ratio);
        torch::Tensor forward(torch::Tensor x);
    private:
        MSA mhsa = nullptr;
        torch::nn::LayerNorm norm1;
        torch::nn::LayerNorm norm2;
        torch::nn::Linear fc1 = nullptr;
        torch::nn::Linear fc2 = nullptr;
        torch::nn::GELU g1 = nullptr;
        int64_t hidden_d;
        int64_t n_heads;
};

TORCH_MODULE(ViTBlock);