# Accelerator Driver
# To Run Matrix Muliplications on the FPGA

- First get libtorch following the README from the root directory

- Go into the `sw` directory
```
mkdir build
cd build
```
- Build the project
```
cmake ..
make
```

- Load the kernel drivers for the FPGA, `PATH_TO_dma_ip_drivers` is the path to [dma_ip_drivers](https://github.com/Xilinx/dma_ip_drivers)
```
cd PATH_TO_dma_ip_drivers/XDMA/linux-kernel/tests && sudo ./load_driver.sh
```
- you can alias the command above as `load_xdma` in `.bashrc` for convenience

- Run the biniaries :)
  - C++
  ```
  sudo ./main
  ```
  - Python
  ```
  python3 example.py
  ```
