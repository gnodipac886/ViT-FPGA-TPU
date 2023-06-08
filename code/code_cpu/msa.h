#pragma once

#include <torch/torch.h>

class MSAImpl : public torch::nn::Module {
    public:
        MSAImpl(int64_t d, int64_t n_heads);
        torch::Tensor forward(torch::Tensor sequences);
    private:
        torch::nn::ModuleList q_mappings;
        torch::nn::ModuleList k_mappings;
        torch::nn::ModuleList v_mappings;
        int64_t d_head;
        const int64_t nheads;
};

TORCH_MODULE(MSA);