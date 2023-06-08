#ifndef MATRIX_UTILS_H
#define MATRIX_UTILS_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef _Float16 float16_t;

void set_consecutive(float16_t * buf, int M, int N) {
	for (int i = 0; i < M * N; i++) {
		buf[i] = (float16_t)((float)i * 1);
		// buf[i] = *((float16_t*)&i);
	}
}

void set_row_col_consecutive(float16_t * buf, int M, int N) {
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			float16_t temp = i < j ? (float16_t)i+1 : (float16_t)j+1;
			buf[i * M + j] = (float16_t)(temp * (0.01));
		}
	}
}

void set_eye_matrix_f16(float16_t * buf, int M, int N) {
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			if (i == j)
				buf[i * N + j] = 1.0;
			else
				buf[i * N + j] = 0.0;
		}
	}
}

void set_all_matrix_f16(float16_t * buf, int M, int N, float16_t data) {
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			buf[i * N + j] = data;
		}
	}
}

void print_imatrix(void * buf, int M, int N, size_t size) {
	printf("\n");
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			if (((float16_t *)buf)[i * N + j] >= 0)
				printf(" %.2f ", ((float16_t *)buf)[i * N + j]);
			else
				printf("%.2f ", ((float16_t *)buf)[i * N + j]);
		}
		printf("\n");
	}
}

void print_xmatrix(void * buf, int M, int N, size_t size) {
	printf("hex: \n");
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			printf("%x  ", ((uint16_t *)buf)[i * N + j]);
		}
		printf("\n");
	}
}

void skew_matrix(void * skew, void * orig, int M, int N, size_t size) {
	// traverse all the rows
	int skew_N = (N << 1) - 1;

	for (int i = 0; i < M; i++) {
		switch (size)
		{
			case sizeof(uint8_t):
				memcpy(&(((uint8_t*)skew)[i * skew_N + i]), &(((uint8_t*)orig)[i * N]), size * N);
				break;

			case sizeof(uint16_t):
				memcpy(&(((uint16_t*)skew)[i * skew_N + i]), &(((uint16_t*)orig)[i * N]), size * N);
				break;

			case sizeof(uint32_t):
				memcpy(&(((uint32_t*)skew)[i * skew_N + i]), &(((uint32_t*)orig)[i * N]), size * N);
				break;

			case sizeof(uint64_t):
				memcpy(&(((uint64_t*)skew)[i * skew_N + i]), &(((uint64_t*)orig)[i * N]), size * N);
				break;
			
			default:
				break;
		}
	}
}


void outer_product_mmm(float16_t const *A, float16_t const *B, float16_t *C, int M, int N, int K)
{
    for (int i = 0; i < K; i++) {
        for (int j = 0; j < M; j++) {
            for (int k = 0; k < N; k++) {
                C[j * N + k] += A[j * K + i] * B[i * N + k];
            }
        }
    }
}

#endif