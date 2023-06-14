/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#ifndef TB_UTILS_H
#define TB_UTILS_H
#include <vpi_user.h>
#include "type.h"
void tb_vpi_put_logic_u8_t(vpiHandle argv, u8_t var);

void tb_vpi_put_logic_u32_t(vpiHandle argv, u32_t var);

static inline void tb_vpi_put_logic_u16_t(vpiHandle argv, u16_t var){
	tb_vpi_put_logic_u32_t(argv, (u32_t) var);
};

void tb_vpi_put_logic_u64_t(vpiHandle argv, u64_t var);

void tb_vpi_put_logic_u48_t(vpiHandle argv, u48_t var);


// puts an array of char_t of variable length to a vector
void _tb_vpi_put_logic_char_var_arr(vpiHandle argv, char_t *arr, size_t len);

#define TB_UTILS_PUT_CHAR_ARR(X) \
 static inline void tb_vpi_put_logic_char_##X##_t(vpiHandle argv, char_t *arr){ \
	_tb_vpi_put_logic_char_var_arr( argv, arr, X ); \
}
static inline void tb_vpi_put_logic_char_t(vpiHandle argc, char_t var){
	tb_vpi_put_logic_u8_t(argc, (u8_t) var);
 }
TB_UTILS_PUT_CHAR_ARR(2)
TB_UTILS_PUT_CHAR_ARR(4)
TB_UTILS_PUT_CHAR_ARR(8)
TB_UTILS_PUT_CHAR_ARR(10)
TB_UTILS_PUT_CHAR_ARR(20)


static inline void tb_vpi_put_logic_price_4_t(vpiHandle argc, price_4_t var){
	tb_vpi_put_logic_u32_t(argc,(u32_t) var);
 }

static inline void tb_vpi_put_logic_price_8_t(vpiHandle argc, price_8_t var){
	tb_vpi_put_logic_u64_t(argc,(u64_t) var);
 }

#endif // TB_UTILS_H
