/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#ifndef TB_UTILS_H
#define TB_UTILS_H
#include <vpi_user.h>

void tb_vpi_logic_put_1b(vpiHandle argv, uint8_t var);

void tb_vpi_logic_put_32b(vpiHandle argv, uint32_t var);

static inline void tb_vpi_logic_put_8b(vpiHandle argv, uint8_t var){
	tb_vpi_logic_put_32b(argv, (uint32_t) var);
};
static inline void tb_vpi_logic_put_16b(vpiHandle argv, uint16_t var){
	tb_vpi_logic_put_32b(argv, (uint32_t) var);
};

void tb_vpi_logic_put_64b(vpiHandle argv, uint64_t var);

void tb_vpi_logic_put_48b(vpiHandle argv, uint8_t var[6]);

// puts an array of uint8_t of variable length to a vector
void _tb_vpi_logic_put_8b_var_arr(vpiHandle argv, uint8_t *arr, size_t len);

#define TB_UTILS_PUT_8B_ARR(X) \
 static inline void tb_vpi_logic_put_##X##b(vpiHandle argv, uint8_t *arr){ \
	_tb_vpi_logic_put_8b_var_arr( argv, arr, X ); \
}

TB_UTILS_PUT_8B_ARR(80)
TB_UTILS_PUT_8B_ARR(160)

#endif // TB_UTILS_H
