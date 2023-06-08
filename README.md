# ViT-FPGA-Accelerator
FPGA based Vision Transformer accelerator (Harvard CS205)

## NOTE: 
FPGA 32x32 code was accidentally deleted from the `code/fpga` directory before the deadline, please see `code/cpu_code/fpga/` for the 32x32 configuration and `code/fpga` for the 16x16 config and testbenches.

# To Run ViT in libTorch (PyTorch C++ API)
#### Go into the `code/code_cpu` directory
- `cd code/code_cpu`
- Everything below is done in the `code/code_cpu` directory!!!

#### First we download the LibTorch library if it's not in the folder yet:
- `wget https://download.pytorch.org/libtorch/nightly/cpu/libtorch-shared-with-deps-latest.zip`
- `unzip libtorch-shared-with-deps-latest.zip`

#### Then build the project
- `mkdir build`
- `cd build`
- `cmake -DCMAKE_PREFIX_PATH=/absolute/path/to/libtorch_folder/that/you/just/downloaded ..`
- `cmake --build . --config Release`
- `cd ..` (we exit the `build` directory)

#### Then download the MNIST dataset if it's not in the folder yet:
- `python download_mnist.py`
- `mkdir mnist`
- Put all the downloaded `.ubyte` files into `./mnist` folder

#### Run the model :)
- `cd build`
- run `./main` with either `test` (test model with loaded weights) or `train`
- You can move job.sh into build directory and run `./job.sh` to get time benchmarks in output.txt
- Pretrained weights can be downloaded here: [Drive](https://drive.google.com/drive/folders/1A7SSotTqGF_dax9yL8jX7Qt5W7MeOm-j?usp=share_link) (90%+ acc) or use the one in the folder (~86% accuracy)

## FPGA Verification:
Please see the video in the root directory for our code's verification on the FPGA side.

## FPGA Testbench
Please checkout `code/fpga/test_accel/test_accel.srcs/sim_1/imports/src/` for the testbenches. Please also import the files in `code/fpga/test_accel/test_accel.srcs/sources_1/imports/src/` as the rtl sources. The testbench demonstrates the controller working in parallel with the DMA engine "spad_arbiter". Please feel free to email Eric for further questions.

## Contribution:
|Name |Contribution|
|-----------|--------------------------------------------------------------------------|
| Eric      | FPGA Matrix Multiplication Design + Code, SW/HW Co-Design                |
| Hongyi    | ViT on Pytorch C++, SW/HW Co-Design and Integration                      |
| Wenyun    | ViT on Pytorch C++, Test and Benchmark (and corresponding shell scripts) |
| Sebastian | ViT and FPGA literature research, FPGA demo + testing                    |
