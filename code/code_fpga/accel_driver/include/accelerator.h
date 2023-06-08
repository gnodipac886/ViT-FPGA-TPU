#ifndef ACCELERATOR_H
#define ACCELERATOR_H

#include <stdint.h>

#define MATRIX_SIZE		16
#define ACCEL_ADDR 		0x200000000
#define ACCEL_ADDR_LMT 	1 << 16
#define FPGA_DATA_WIDTH	(MATRIX_SIZE == 16 ? 128/8 : 1024/8)
#define REG_SHIFT_AMT 	(MATRIX_SIZE == 16 ? 6 : 7)		// log2 of FPGA_DATA_WIDTH

// #define FPGA_DATA_WIDTH	1024/8
// #define REG_SHIFT_AMT 	7		// log2 of FPGA_DATA_WIDTH

typedef struct {
	uint32_t data[FPGA_DATA_WIDTH/sizeof(uint32_t)];
} fpga_data_t;

typedef enum { 
	R_MATRIX_A_ADDR 			= ACCEL_ADDR + (0 << REG_SHIFT_AMT),
	R_MATRIX_B_ADDR 			= ACCEL_ADDR + (1 << REG_SHIFT_AMT),
	R_MATRIX_C_ADDR 			= ACCEL_ADDR + (2 << REG_SHIFT_AMT),
	R_MATRIX_A_SIZE 			= ACCEL_ADDR + (3 << REG_SHIFT_AMT),		// sizes in terms of bytes
	R_MATRIX_B_SIZE 			= ACCEL_ADDR + (4 << REG_SHIFT_AMT),
	R_MATRIX_RD_CNT 			= ACCEL_ADDR + (5 << REG_SHIFT_AMT),		// TODO: we might want to have fp32 for answer
	R_MATRIX_M_SIZE 			= ACCEL_ADDR + (6 << REG_SHIFT_AMT),
	R_MATRIX_N_SIZE 			= ACCEL_ADDR + (7 << REG_SHIFT_AMT),
	R_MATRIX_K_SIZE 			= ACCEL_ADDR + (8 << REG_SHIFT_AMT),
	R_ACCEL_INSTR				= ACCEL_ADDR + (9 << REG_SHIFT_AMT),
	R_ACCEL_STATE 				= ACCEL_ADDR + (10 << REG_SHIFT_AMT),
	R_ACCEL_DATA				= ACCEL_ADDR + (11 << REG_SHIFT_AMT),
	R_SYS_ARR_OUTPUT			= ACCEL_ADDR + (12 << REG_SHIFT_AMT)
} accel_mmio_reg_e;

typedef enum { 
	I_IDLE				= 0,
	I_R_MAT_A			= 1,
	I_R_MAT_B			= 2,
	I_R_MAT_C			= 3,
	I_GEMM				= 4,
	I_RESET				= 5
} accel_instr_e;

typedef enum {  
	S_IDLE				= 0,
	S_WAIT_ARW_READY	= 1,
	S_WAIT_RW			= 2,
	S_WAIT_COMPUTE		= 3,
	S_SEND_MAT_C		= 4,
	S_DONE				= 5
} accel_state_e;

#endif