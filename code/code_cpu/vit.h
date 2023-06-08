#pragma once

#include <torch/torch.h>
#include "vit_block.h"

class ViTImpl : public torch::nn::Module {
 public:
    ViTImpl(int64_t c, int64_t h, int64_t w, int64_t n_patches, int64_t n_blocks, int64_t hidden_d, int64_t n_heads, int64_t out_d);
    torch::Tensor forward(torch::Tensor x);
 private:
    torch::Tensor patchify(torch::Tensor images, int64_t n_patches);
    torch::Tensor get_positional_embeddings(int64_t sequence_length, int64_t d);
    torch::Tensor class_token, pos_embed;
    torch::nn::Linear linear_mapper  = nullptr;
    torch::nn::Linear mlp  = nullptr;
    torch::nn::ModuleList blocks;
    int64_t n_patches;
};

TORCH_MODULE(ViT);
