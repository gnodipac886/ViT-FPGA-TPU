cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
project(main)

set(CMAKE_CXX_COMPILER /usr/bin/g++-12)
set(CMAKE_PREFIX_PATH /home/ericd/libtorch)
set(CMAKE_BUILD_PARALLEL_LEVEL 8)
set(GCC_COVERAGE_COMPILE_FLAGS "-fPIC -shared")

find_package(Torch REQUIRED)

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/src)

ADD_LIBRARY(fpga_gemm SHARED
	${CMAKE_SOURCE_DIR}/include/accelerator.h
	${CMAKE_SOURCE_DIR}/include/dma_utils.h
	${CMAKE_SOURCE_DIR}/include/matrix_utils.h
	${CMAKE_SOURCE_DIR}/src/main.cpp 
)
target_link_libraries(fpga_gemm "${TORCH_LIBRARIES}")
add_executable(${PROJECT_NAME} 
	${CMAKE_SOURCE_DIR}/include/accelerator.h
	${CMAKE_SOURCE_DIR}/include/dma_utils.h
	${CMAKE_SOURCE_DIR}/include/matrix_utils.h
	${CMAKE_SOURCE_DIR}/src/main.cpp 
)
target_link_libraries(${PROJECT_NAME} "${TORCH_LIBRARIES}")
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 23)