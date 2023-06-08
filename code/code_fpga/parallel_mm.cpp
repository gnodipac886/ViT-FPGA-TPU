#include <omp.h>
#include <immintrin.h>
#include <iostream>
#include <cmath>

void matmul(float* a, float* b, float* c, int m, int n) {
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            float sum = 0.0;
            for (int k = 0; k < m; k++) {
                sum += a[i * m + k] * b[k * n + j];
            }
            c[i * n + j] = sum;
        }
    }
}

// Calculate C(m,n) = A(m,m) * B(m,n)
void mm(float* A, float* B, float* C, int m, int n) {
    // __m256 sum, a, b; 
    #pragma omp parallel for collapse(2)
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            // sum = _mm256_setzero_ps();
            // for (int l = 0; l < 48; l += 8) {
            //     a = _mm256_loadu_ps(&A[i * m + l]);
            //     b = _mm256_loadu_ps(&B[l * n + j]);
            //     sum = _mm256_add_ps(sum, _mm256_mul_ps(a, b));
            // }
            // float res[8];
            // _mm256_storeu_ps(res, sum);
            // C[i * n + j] = res[0] + res[1] + res[2] + res[3] + res[4] + res[5] + res[6] + res[7] + A[i * m + 48] * B[48 * n + j] + A[i * m + 49] * B[49 * n + j];
            for (int k = 0; k < m; k++){
                C[i*n+j] += A[i*m+k] * B[k*n+j];
            }
        }
    }
}

// Calculate C = A * B.T
void transpose_mm(float* A, float* B, float* C, int m, int n) {
    __m256 sum, a, b; 
    #pragma omp parallel for collapse(2)
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < m; j++) {
            sum = _mm256_setzero_ps();
            for (int l = 0; l < n; l += 8) {
                a = _mm256_load_ps(&A[i * n + l]);
                b = _mm256_load_ps(&B[j * n + l]);
                sum = _mm256_add_ps(sum, _mm256_mul_ps(a, b));
            }
            float res[8];
            _mm256_storeu_ps(res, sum);
            C[i * m + j] = res[0] + res[1] + res[2] + res[3] + res[4] + res[5] + res[6] + res[7];
        }
    }
}

// Calculate torch::functional::softmax(A, /*dim=*/1)
// void softmax(float *A, int m) {
//     __m256 inv_exp_sum_vec, A_vec;
//     __m256 one_vec = _mm256_set1_ps(1.0);

//     #pragma omp parallel for simd
//     for (int i = 0; i < m; i++) {
        
//         float sum = 0;
//         # pragma omp parallel for reduction(+ : sum)
//         for (int j = 0; j < m; j ++) {
//             float tot = exp(A[i*m+j]);
//             A[i*m+j] = tot;
//             sum += tot;
//         }
        

//         inv_exp_sum_vec = _mm256_div_ps(_mm256_set1_ps(1.0), _mm256_set1_ps(sum));

//         #pragma omp parallel for simd
//         for (int j = 0; j < 48; j += 8) {
//             A_vec = _mm256_loadu_ps(A + i * m + j);
//             A_vec = _mm256_mul_ps(A_vec, inv_exp_sum_vec);
//             _mm256_storeu_ps(A + i * m + j, A_vec);
//         }
//         A[i*m+48] /= sum;
//         A[i*m+49] /= sum;
//     }
// }
