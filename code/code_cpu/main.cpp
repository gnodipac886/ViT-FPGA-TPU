#include <torch/torch.h>
#include <cmath>
#include <cstdio>
#include <iostream>
#include "vit.h"

using namespace torch;
using namespace std;

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

void test(){
    torch::manual_seed(1);
    auto dataset = torch::data::datasets::MNIST("../mnist", torch::data::datasets::MNIST::Mode::kTest)
    .map(torch::data::transforms::Normalize<>(0.1307, 0.3081))
    .map(torch::data::transforms::Stack<>());
    auto data_loader = torch::data::make_data_loader(
    std::move(dataset),
    torch::data::DataLoaderOptions().batch_size(1024).workers(4));

    torch::nn::CrossEntropyLoss criterion;

    int64_t c = 1;
    int64_t h = 28;
    int64_t w = 28;
    int64_t n_blocks = 2;
    int64_t n_patches = 7;
    int64_t hidden_d = 128;
    int64_t n_heads = 4;
    int64_t out_d = 10;
    ViT model = ViT(c,h,w,n_patches, n_blocks, hidden_d, n_heads, out_d);

    // Change the path of your weight here.
    torch::load(model, "../model-checkpoint_train2.pt");

    cout << "Loaded pretrained models" << endl;

    torch::NoGradGuard no_grad;
    int64_t batch_index = 0;
    double train_loss = 0.0;
    float correct = 0;
    for (torch::data::Example<>& batch : *data_loader) {
        model->zero_grad();
        torch::Tensor input_images = batch.data; // Shape = (N, 1, 28, 28), N = batch size
        torch::Tensor labels = batch.target; // Shape = (N)

        torch::Tensor out = model->forward(input_images);
        auto loss = torch::nll_loss(out, labels);
        auto pred = out.argmax(1);
        correct += pred.eq(labels).sum().item<float>();
    }
    cout << "test accuracy: " << correct / 10000 << endl;
}


void train(){
    torch::manual_seed(1);
    auto dataset = torch::data::datasets::MNIST("../mnist")
    .map(torch::data::transforms::Normalize<>(0.1307, 0.3081))
    .map(torch::data::transforms::Stack<>());
    auto data_loader = torch::data::make_data_loader(
    std::move(dataset),
    torch::data::DataLoaderOptions().batch_size(1024).workers(4));

    int64_t c = 1;
    int64_t h = 28;
    int64_t w = 28;
    int64_t n_blocks = 2;
    int64_t n_patches = 7;
    int64_t hidden_d = 128;
    int64_t n_heads = 4;
    int64_t out_d = 10;
    ViT model = ViT(c,h,w,n_patches, n_blocks, hidden_d, n_heads, out_d);
    torch::optim::Adam optimizer(model->parameters(), torch::optim::AdamOptions(5e-4).betas(std::make_tuple(0.5, 0.5)));

    //torch::load(model, "../model-checkpoint_train.pt");

    for (int64_t epoch = 1; epoch <= 1000; ++epoch) {
        int64_t batch_index = 0;
        double train_loss = 0.0;
        float correct = 0;
        for (torch::data::Example<>& batch : *data_loader) {
            model->zero_grad();
            optimizer.zero_grad();
            torch::Tensor input_images = batch.data; // Shape = (N, 1, 28, 28), N = batch size
            torch::Tensor labels = batch.target; // Shape = (N)
            //labels = labels.reshape({ labels.size(0), 1 }); // Shape = (N, 1)

            torch::Tensor out = model->forward(input_images);
            auto loss = torch::nll_loss(out, labels);
            loss.backward();
            optimizer.step();
            auto pred = out.argmax(1);
            correct = pred.eq(labels).sum().item<float>();
            cout << "train accuracy: " << correct / input_images.size(0) << endl;
        }
        std::cout << "Epoch " << epoch << "/" << 1000 << std::endl;

        if (epoch % 2 == 0){
            torch::save(model, "../model-checkpoint_train2.pt");
            torch::save(optimizer, "../optimizer-checkpoint_train2.pt");
        }
    }
}

int main(int argc, const char* argv[]) {
    if (argc < 2) {
        // Tell the user how to run the program
        std::cerr << "Usage: " << argv[0] << " train/test" << std::endl;
        return 1;
    }

    if (strcmp(argv[1], "test") == 0){
        test();
        return 0;
    } else if (strcmp(argv[1], "train") == 0){
        train();
        return 1;
    } else {
        std::cerr << "Usage: " << argv[0] << " train/test" << std::endl;
        return 1;
    }
}
