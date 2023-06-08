#include <torch/torch.h>
#include <iostream>
#include <cmath>
#include "vit.h"
#include <chrono>

using namespace torch::indexing;

void print_tensor_info(torch::Tensor tensor) {
    std::cout << "Tensor dimension: " << tensor.dim() << std::endl;
    std::cout << "Tensor shape: ";
    for (int64_t dim : tensor.sizes()) {
        std::cout << dim << " ";
    }
    std::cout << std::endl;
}

torch::Tensor ViTImpl::get_positional_embeddings(int64_t seq_length, int64_t d) {
    torch::Tensor out = torch::ones({seq_length, d});

    #pragma omp parallel for collapse(2)
    for (int i = 0; i < seq_length; i++) {
        for (int j = 0; j < d; j++) {
            double temp = j % 2 == 0 ? std::sin(i / std::pow(10000, j / d)) : std::cos(i / std::pow(10000, (j - 1) / d));

            #pragma omp critical
            {
                out.index_put_({i, j}, temp);
            }
        }
    }
    return out;
}

torch::Tensor ViTImpl::patchify(torch::Tensor images, int64_t n_patches){
    // Get the shape of the images tensor
    auto shape = images.sizes();
    int n = shape[0];
    int c = shape[1];
    int h = shape[2];
    int w = shape[3];

    assert(h == w && "Patchify method is implemented for square images only");

    // Initialize the output tensor
    torch::Tensor patches = torch::zeros({n, n_patches * n_patches, h * w * c / (n_patches * n_patches)});

    // Calculate the patch size
    int patch_size = h / n_patches;
    //omp_set_num_threads(16);
    // Loop over each image in the batch
    # pragma omp parallel for schedule(static)
    for (int idx = 0; idx < n; idx++) {
        auto image = images.index({idx});

        // Loop over each patch in the image
        # pragma omp parallel for collapse(2)
        
        for (int i = 0; i < n_patches; i++) {
            for (int j = 0; j < n_patches; j++) {
                // Extract the patch from the image
                // auto patch = image.index({
                //     torch::indexing::Slice(),
                //     torch::indexing::Slice(i * patch_size, (i + 1) * patch_size),
                //     torch::indexing::Slice(j * patch_size, (j + 1) * patch_size)
                // });
                // auto patch = image.narrow(1, i * patch_size, patch_size).narrow(2, j * patch_size, patch_size);
                // Flatten the patch and add it to the output tensor
                patches.index_put_({idx,i * n_patches + j},  image.narrow(1, i * patch_size, patch_size).narrow(2, j * patch_size, patch_size).flatten());
            }
        }
    }

    return patches;
}

ViTImpl::ViTImpl(int64_t c, int64_t h, int64_t w, int64_t n_patches, int64_t n_blocks, int64_t hidden_d, int64_t n_heads, int64_t out_d): n_patches(n_patches){
    int patch_size = h / n_patches;
    int input_d = c * patch_size * patch_size;
    linear_mapper = torch::nn::Linear(input_d, hidden_d);

    // Learnable classification token
    class_token = torch::Tensor(torch::rand({1, hidden_d}));
    register_parameter("class_token", class_token);
        
    // Positional embedding
    pos_embed = get_positional_embeddings(pow(n_patches,2) + 1, hidden_d);
        
    // Transformer encoder blocks [MyViTBlock(hidden_d, n_heads) for _ in range(n_blocks)]
    blocks = torch::nn::ModuleList();
    for (int i = 0; i < n_blocks; i++){
      blocks->push_back(ViTBlock(hidden_d, n_heads, 4));
    }

    //Classification MLP
    mlp = torch::nn::Linear(hidden_d, out_d);

    register_module("lin_map", linear_mapper);
    register_module("blocks", blocks);
    register_module("mlp", mlp);
}

torch::Tensor ViTImpl::forward(torch::Tensor x){
    int n = x.size(0);
    int c = x.size(1);
    int h = x.size(2);
    int w = x.size(3);
    long long patchify_duration = 0;
    long long linear_embedding_duration = 0;
    long long positional_embedding_duration = 0;
    long long vit_block_duration = 0;
    long long classification_duration = 0;

    std::cout << "pytorch get num threads: "<< at::get_num_threads() << std::endl;

    std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
    torch::Tensor patches = patchify(x, n_patches);
    std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
    patchify_duration = std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count();

    //at::omp_set_num_threads(1);
    begin = std::chrono::steady_clock::now();
    torch::Tensor tokens = linear_mapper->forward(patches);
    end = std::chrono::steady_clock::now();
    linear_embedding_duration = std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count();

    begin = std::chrono::steady_clock::now();
    tokens = torch::cat({class_token.expand({n, 1, -1}), tokens}, 1);
    tokens = tokens + pos_embed.repeat({n,1,1});
    end = std::chrono::steady_clock::now();
    positional_embedding_duration = std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count();

    
    for (auto& block : *blocks) {
	        begin = std::chrono::steady_clock::now();
		    tokens = block->as<ViTBlock>()->forward(tokens);
		    end = std::chrono::steady_clock::now();
            std::cout << "Time difference (vit block) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
			vit_block_duration += std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count();
    }

    tokens = tokens.index({torch::indexing::Slice(), 0});

    begin = std::chrono::steady_clock::now();
    tokens = mlp->forward(tokens);
    tokens = torch::nn::functional::softmax(tokens, torch::nn::functional::SoftmaxFuncOptions(0));
    end = std::chrono::steady_clock::now();
    classification_duration = std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count();
    std::cout << "Time difference (patchify) = " << patchify_duration << "[µs]" << std::endl;
    std::cout << "Time difference (linear embedding) = " << linear_embedding_duration << "[µs]" << std::endl;
    std::cout << "Time difference (positional embedding) = " << positional_embedding_duration << "[µs]" << std::endl;
    std::cout << "Time difference (vit block total) = " << vit_block_duration << "[µs]" << std::endl;
    std::cout << "Time difference (classification) = " << classification_duration << "[µs]" << std::endl;
    long long total_duration = patchify_duration + linear_embedding_duration + positional_embedding_duration + vit_block_duration + classification_duration;

    std::cout << "Total time difference = " << total_duration << "[µs]" << std::endl;

   // std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
   // torch::Tensor patches = patchify(x, n_patches);
    //std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
   // std::cout << "Time difference (patchify) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

   // begin = std::chrono::steady_clock::now();
    //torch::Tensor tokens = linear_mapper->forward(patches);
    //end = std::chrono::steady_clock::now();
   // std::cout << "Time difference (linear embedding) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

   // begin = std::chrono::steady_clock::now();
   // tokens = torch::cat({class_token.expand({n, 1, -1}), tokens}, 1);
   // tokens = tokens + pos_embed.repeat({n,1,1});
   // end = std::chrono::steady_clock::now();
   // std::cout << "Time difference (positional embedding) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

   // for (auto& block : *blocks) {
       // begin = std::chrono::steady_clock::now();
       // tokens = block->as<ViTBlock>()->forward(tokens);
       // end = std::chrono::steady_clock::now();
       // std::cout << "Time difference (vit block) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
   // }

   // tokens = tokens.index({torch::indexing::Slice(), 0});

   // begin = std::chrono::steady_clock::now();
   // tokens = mlp->forward(tokens);
   // tokens = torch::nn::functional::softmax(tokens, torch::nn::functional::SoftmaxFuncOptions(0));
   // end = std::chrono::steady_clock::now();
   // std::cout << "Time difference (classification) = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;

    return tokens;
}
