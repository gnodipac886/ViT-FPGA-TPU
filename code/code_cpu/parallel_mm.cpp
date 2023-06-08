#include <omp.h>
#include <immintrin.h>
#include <iostream>
#include <cmath>


// Calculate C = A * B.T
void transpose_mm(float* A, float* B, float* C, int m, int n) {
    __m256 sum, a, b; 
    float res[8];
    #pragma omp parallel for collapse(2) private(res)
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < m; j++) {
            sum = _mm256_setzero_ps();
            for (int l = 0; l < n; l += 8) {
                a = _mm256_load_ps(&A[i * n + l]);
                b = _mm256_load_ps(&B[j * n + l]);
                sum = _mm256_fmadd_ps(a, b, sum);
            }
            _mm256_storeu_ps(res, sum);
            C[i * m + j] = res[0] + res[1] + res[2] + res[3] + res[4] + res[5] + res[6] + res[7];
        }
    }
}

// Calculate sum(A, dim=0)
void row_reduce(float *out, float *matrix, int rows, int cols){
    #pragma omp parallel for
    for (int i = 0; i < rows; i++) {
        float row_sum = 0.0;
        #pragma omp simd reduction(+:row_sum)
        for (int j = 0; j < cols; j++) {
            row_sum += matrix[i*cols + j];
        }
        out[i] = row_sum;
    }
}
