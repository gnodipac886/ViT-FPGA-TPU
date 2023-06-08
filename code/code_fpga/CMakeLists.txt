cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
project(main)

find_package(Torch REQUIRED)
set(CMAKE_CXX_COMPILER /usr/bin/g++-12)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS} -pthread -fopenmp -mavx2")
include_directories(/home/ericd/pci/team15/code/accel_driver/include)

set(EXECUTABLE_NAME main)
add_executable(${EXECUTABLE_NAME})

# add_executable(${PROJECT_NAME} 
	# /home/ericd/pci/team15/code/accel_driver/include/accelerator.h
	# /home/ericd/pci/team15/code/accel_driver/include/dma_utils.h
	# /home/ericd/pci/team15/code/accel_driver/include/matrix_utils.h
# )

target_sources(${EXECUTABLE_NAME} PRIVATE main.cpp
	/home/ericd/pci/team15/code/accel_driver/include/accelerator.h
	/home/ericd/pci/team15/code/accel_driver/include/dma_utils.h
	/home/ericd/pci/team15/code/accel_driver/include/matrix_utils.h
  vit.cpp
  vit_block.cpp
  msa.cpp
  msa.h
  vit_block.h
  vit.h
  fpga.h
)
target_link_libraries(main "${TORCH_LIBRARIES}")
set_property(TARGET main PROPERTY CXX_STANDARD 14)

# The following code block is suggested to be used on Windows.
# According to https://github.com/pytorch/pytorch/issues/25457,
# the DLLs need to be copied to avoid memory errors.
if (MSVC)
  file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
  add_custom_command(TARGET main
                     POST_BUILD
                     COMMAND ${CMAKE_COMMAND} -E copy_if_different
                     ${TORCH_DLLS}
                     $<TARGET_FILE_DIR:main>)
endif (MSVC)