from ctypes import *
# import torch
import numpy as np

so_file = "../build/libfpga_gemm.so"
lib = CDLL(so_file)
print(lib.get_fpga_matrix_size())

# def fpga_gemm(a: np.array, b: np.array) -> np.array:
# 	so_file = "../build/libfpga_gemm.so"
# 	lib = CDLL(so_file)
# 	c = np.zeros((a.shape[0], b.shape[1]), dtype=np.float16)
# 	lib.gemm_ptr(a.ctypes.data_as(POINTER(c_float)), b.ctypes.data_as(POINTER(c_float)), c.ctypes.data_as(POINTER(c_float)), a.shape[0], a.shape[1], b.shape[1])
# 	return np.round(c, 3)

def fpga_gemm_pad(a: np.array, b: np.array) -> np.array:
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

	print(m_pad, k_pad, n_pad)

	a_pad[:m, :k] = a
	b_pad[:k, :n] = b

	lib.gemm_padded_ptr(a_pad.ctypes.data_as(POINTER(c_float)), b_pad.ctypes.data_as(POINTER(c_float)), c_pad.ctypes.data_as(POINTER(c_float)), a_pad.shape[0], a_pad.shape[1], b_pad.shape[1])
	c[:m, :n] = c_pad[:m, :n]
	return np.round(c, 3)

mat_size = 50

a = np.random.rand(mat_size, mat_size).astype(np.float16) / 10
# a = np.ones((mat_size, mat_size), dtype=np.float16)
# a = np.arange(0, mat_size * mat_size, dtype=np.float16).reshape(mat_size, mat_size) / 100
b = np.random.rand(mat_size, mat_size).astype(np.float16) / 10
# b = np.ones((mat_size, mat_size), dtype=np.float16)
# b = np.eye(mat_size, dtype=np.float16)

# c = fpga_gemm(a, b)
# print(c[:16, :16])
# print(np.matmul(a, b)[:16, :16])

c = fpga_gemm_pad(a, b)
print(c[-10:, -10:])
print(np.matmul(a, b)[-10:, -10:])