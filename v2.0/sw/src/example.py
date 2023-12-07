from ctypes import *
# import torch
import numpy as np
import time
import psutil

so_file = "../build/libfpga_gemm.so"
lib = CDLL(so_file)
sys_size = lib.get_fpga_matrix_size()
print(f"Systolic Array Size: {sys_size} x {sys_size}", )

# def fpga_gemm(a: np.array, b: np.array) -> np.array:
# 	so_file = "../build/libfpga_gemm.so"
# 	lib = CDLL(so_file)
# 	c = np.zeros((a.shape[0], b.shape[1]), dtype=np.float16)
# 	lib.gemm_ptr(a.ctypes.data_as(POINTER(c_float)), b.ctypes.data_as(POINTER(c_float)), c.ctypes.data_as(POINTER(c_float)), a.shape[0], a.shape[1], b.shape[1])
# 	return np.round(c, 3)

def fpga_gemm_pad(a: np.array, b: np.array) -> (np.array, float):
	so_file = "../build/libfpga_gemm.so"
	lib = CDLL(so_file)
	MATRIX_SIZE = lib.get_fpga_matrix_size()
	c = np.zeros((a.shape[0], b.shape[1]), dtype=np.float16)

	m, k, n = a.shape[0], a.shape[1], b.shape[1]
	m_pad = np.ceil(m / MATRIX_SIZE).astype(int) * MATRIX_SIZE
	k_pad = np.ceil(k / MATRIX_SIZE).astype(int) * MATRIX_SIZE
	n_pad = np.ceil(n / MATRIX_SIZE).astype(int) * MATRIX_SIZE

	a_pad = np.zeros((m_pad, k_pad), dtype=np.float16)
	b_pad = np.zeros((k_pad, n_pad), dtype=np.float16)
	c_pad = np.zeros((m_pad, n_pad), dtype=np.float16)

	print(f"Padded Dimension: M: {m_pad}, K: {k_pad}, N: {n_pad}")

	a_pad[:m, :k] = a
	b_pad[:k, :n] = b

	gemm_padded_ptr = lib.gemm_padded_ptr
	gemm_padded_ptr.restype = c_float
	compute_time = lib.gemm_padded_ptr(a_pad.ctypes.data_as(POINTER(c_float)), b_pad.ctypes.data_as(POINTER(c_float)), c_pad.ctypes.data_as(POINTER(c_float)), a_pad.shape[0], a_pad.shape[1], b_pad.shape[1])
	c[:m, :n] = c_pad[:m, :n]
	return np.round(c, 3), compute_time

mat_size = 150

a = np.random.rand(mat_size, mat_size).astype(np.float16) / 10
# a = np.ones((mat_size, mat_size), dtype=np.float16)
# a = np.arange(0, mat_size * mat_size, dtype=np.float16).reshape(mat_size, mat_size) / 100
b = np.random.rand(mat_size, mat_size).astype(np.float16) / 10
# b = np.ones((mat_size, mat_size), dtype=np.float16)
# b = np.eye(mat_size, dtype=np.float16)

# c = fpga_gemm(a, b)
# print(c[:16, :16])
# print(np.matmul(a, b)[:16, :16])

fpga_freq = 200e6
start = time.time()
c, compute_time = fpga_gemm_pad(a, b)
end = time.time()
time_elapsed = end - start
throughput_per_second = mat_size ** 3 / time_elapsed / 1e9
cycles = int(time_elapsed * fpga_freq)
throughput_per_cycle = mat_size ** 3 / (time_elapsed * fpga_freq)
raw_fpga_throughput_per_second = mat_size ** 3 / compute_time / 1e9
raw_fpga_throughput_per_cycle = mat_size ** 3 / (compute_time * fpga_freq)
fpga_max_throughput_per_cycle = (sys_size ** 2) * 2
fpga_max_throughput_per_second = fpga_max_throughput_per_cycle * fpga_freq / 1e9
print()
print(f"FPGA Time: {time_elapsed:.3f} s")
print(f"FPGA Raw Compute: {compute_time:.3f} s")
print(f"FPGA Cycles: {cycles}")
print(f'FPGA Raw Compute Cycles: {int(compute_time * fpga_freq)}')
print(f"FPGA Throughput per second: {throughput_per_second:.3f} GFLOPS (fp16)")
print(f'FPGA Throughput per cycle: {throughput_per_cycle:.3f} GFLOP/cycle (fp16)')
print(f'FPGA Raw Throughput per second: {raw_fpga_throughput_per_second:.3f} GFLOPS (fp16)')
print(f'FPGA Raw Throughput per cycle: {raw_fpga_throughput_per_cycle:.3f} GFLOP/cycle (fp16)')
print(f'FPGA Max Throughput per second: {fpga_max_throughput_per_second:.2f} GFLOPS (fp16)')
print(f'FPGA Max Throughput per cycle: {fpga_max_throughput_per_cycle:.2f} GFLOP/cycle (fp16)')
print()

start = time.time()
c = a @ b
end = time.time()
# cpu_freq = psutil.cpu_freq().current * 1e6
cpu_freq = psutil.cpu_freq().max * 1e6
time_elapsed = end - start
throughput_per_second = mat_size ** 3 / time_elapsed / 1e9
cycles = int(time_elapsed * cpu_freq)
throughput_per_cycle = mat_size ** 3 / (time_elapsed * cpu_freq)
print(f"CPU Time: {time_elapsed:.3f} s")
print(f"CPU Cycles: {cycles}")
print(f"CPU Throughput per second: {throughput_per_second:.3f} GFLOPS (fp16)")
print(f'CPU Throughput per cycle: {throughput_per_cycle:.3f} GFLOP/cycle (fp16)')


# print(c[-10:, -10:])
# print(np.matmul(a, b)[-10:, -10:])