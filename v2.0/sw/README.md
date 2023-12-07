# Accelerator Driver
# To Run Matrix Muliplications on the FPGA

#### First get libtorch following the README from the root directory

#### Go into the `sw` directory
- `cd sw/build`
- Everything below is done in the `build` directory of the Hyperion server with the FPGA using Eric's account!!!

#### Build the project
- `cmake ..`
- `make`

#### Load the kernel drivers for the FPGA
- `cd PATH_TO_dma_ip_drivers/XDMA/linux-kernel/tests && sudo ./load_driver.sh`
- you can alias the command above as `load_xdma` in `.bashrc` for convenience

#### Run the biniaries :)
- `sudo ./main`
- `python3 example.py`