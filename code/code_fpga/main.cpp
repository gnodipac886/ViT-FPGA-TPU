#include <torch/torch.h>
#include <cmath>
#include <cstdio>
#include <iostream>
#include "vit.h"
// #include "fpga.h"

using namespace torch;

void print_tensor_info_main(torch::Tensor tensor) {
    std::cout << "Tensor dimension: " << tensor.dim() << std::endl;
    std::cout << "Tensor shape: ";
    for (int64_t dim : tensor.sizes()) {
        std::cout << dim << " ";
    }

    std::cout << tensor.index({0}) << std::endl;
}

torch::Tensor one_hot_encode(torch::Tensor labels, int num_classes) {
  auto N = labels.size(0);
  auto device = labels.device();

  // Create a zero tensor of size {N, num_classes}
  auto one_hot = torch::zeros({N, num_classes}, torch::kFloat32).to(device);

  // Set the appropriate indices to 1
  for (int i = 0; i < N; i++) {
    int label = labels[i].item<int>();
    one_hot[i][label] = 1;
  }

  return one_hot;
}


int main(int argc, const char* argv[]) {
    // torch::set_default_dtype(scalarTypeToTypeMeta(ScalarType::Half));
    torch::manual_seed(1234);
    auto dataset = torch::data::datasets::MNIST("../mnist")
    .map(torch::data::transforms::Normalize<>(0.5, 0.5))
    .map(torch::data::transforms::Stack<>());
    auto data_loader = torch::data::make_data_loader(
    std::move(dataset),
    torch::data::DataLoaderOptions().batch_size(64).workers(1));

    torch::nn::CrossEntropyLoss criterion;

    int64_t c = 1;
    int64_t h = 28;
    int64_t w = 28;
    int64_t n_blocks = 2;
    int64_t n_patches = 7;
    int64_t hidden_d = 64;
    int64_t n_heads = 4;
    int64_t out_d = 10;
    ViT model = ViT(c,h,w,n_patches, n_blocks, hidden_d, n_heads, out_d);
    torch::optim::Adam optimizer(model->parameters(), torch::optim::AdamOptions(2e-4).betas(std::make_tuple(0.5, 0.5)));

    //torch::load(model, "../model-checkpoint.pt");
    //torch::load(optimizer, "../optimizer-checkpoint.pt");

    for (int64_t epoch = 1; epoch <= 10; ++epoch) {
        int64_t batch_index = 0;
        double train_loss = 0.0;
        for (torch::data::Example<>& batch : *data_loader) {
            model->zero_grad();
            torch::Tensor input_images = batch.data; // Shape = (N, 1, 28, 28), N = batch size
            torch::Tensor labels = batch.target; // Shape = (N)
            labels = labels.reshape({ labels.size(0), 1 }); // Shape = (N, 1)

            // std::cout << "dim1: " << input_images.dim() << std::endl;
            // std::cout << "dim2: " << labels.dim() << std::endl;
            // std::cout << "shape: " << input_images.size(0) << ' ' << input_images.size(1) << ' ' << input_images.size(2) << ' ' << input_images.size(3) << std::endl;
            // std::cout << "shape: " << labels.size(0) << " " << labels.size(1) << std::endl;
            torch::Tensor out = model->forward(input_images);
            // torch::Tensor y = one_hot_encode(labels, 10);
            std::cout << out.index({0}) << std::endl;
            // print_tensor_info_main(out);
            // print_tensor_info_main(y);
            // auto loss = criterion(out, y);
            // loss.backward();
            // optimizer.step();
            // train_loss += loss.item<double>() / 60000;
            //print_tensor_info_main(out);
            break;
        }
        break;
        std::cout << "Epoch " << epoch << "/" << 10 << " loss: " << train_loss << std::endl;
        if (epoch == 10){
            torch::save(model, "model-checkpoint.pt");
            torch::save(optimizer, "optimizer-checkpoint.pt");
        }
    }
}
