# Accelerator Driver
# To Run Matrix Muliplications on the FPGA

#### First get libtorch following the README from the root directory

#### Go into the `accel_driver` directory
- `cd accel_driver/build`
- Everything below is done in the `build` directory of the Hyperion server with the FPGA using Eric's account!!!

#### Build the project
- `cmake ..`
- `make`

#### Load the kernel drivers for the FPGA
- `load_xdma`

#### Run the biniaries :)
- `sudo ./main`