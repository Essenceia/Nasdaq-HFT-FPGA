/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#include "tb_utils.h"
#include <assert.h>
#include <stdlib.h>
/* Note : Eventhough calloc set bits to 0 we are still manually
 * writing bval's to 0 for clarity */

void tb_vpi_put_logic_1b_t(vpiHandle argv, uint8_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiScalarVal;
	v.value.scalar = ( var )? vpi1 : vpi0;
	vpi_put_value(h, &v, 0, vpiNoDelay);
}

void tb_vpi_put_logic_u8_t(vpiHandle argv, u8_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(1, sizeof(s_vpi_vecval));
	v.value.vector[0].aval = (PLI_INT32) 0xffffff00 | (PLI_INT32)var;
	v.value.vector[0].bval = (PLI_INT32) 0xffffff00;
	vpi_put_value(h, &v, 0, vpiNoDelay);
	free(v.value.vector);	
}
void tb_vpi_put_logic_u32_t(vpiHandle argv, u32_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(1, sizeof(s_vpi_vecval));
	v.value.vector[0].aval = (PLI_INT32)var;
	v.value.vector[0].bval = 0;
	vpi_put_value(h, &v, 0, vpiNoDelay);
	free(v.value.vector);	
}

void tb_vpi_put_logic_u64_t(vpiHandle argv, u64_t var){
	vpiHandle h;
	s_vpi_value v;
	assert(argv);
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(2, sizeof(s_vpi_vecval));
	v.value.vector[0].aval =(PLI_INT32) var; //32 lsb 
	v.value.vector[0].bval = 0;
	v.value.vector[1].aval =(PLI_INT32) ( var >> 32 ); //32 msb 
	v.value.vector[1].bval = 0;
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}

void tb_vpi_put_logic_u48_t(vpiHandle argv, u48_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	u64_t var64 = 0;
	v.format = vpiVectorVal;
	v.value.vector = calloc(2, sizeof(s_vpi_vecval));
	// convert 8b array to 64b variable for ease of use 
	for( int i=0; i < 6; i++){
		var64 |= (u64_t)var[i] << i*8; 
	}
	/* bit encoding: ab: 00=0, 10=1, 11=X, 01=Z 
 	*  set 16 msb to X, keep only 48 lsb */
	v.value.vector[0].aval =(PLI_INT32) var64; //32 lsb 
	v.value.vector[0].bval = 0;
	v.value.vector[1].aval =(PLI_INT32) ( 0xffff0000 | ( var64 >> 32 )); //32 msb
	v.value.vector[1].bval =(PLI_INT32)  0xffff0000;
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}


void _tb_vpi_put_logic_char_var_arr(vpiHandle argv, char_t *arr, size_t len){
	size_t w_cnt; // word count, vpi vector val elems are only of 32b wide each
	size_t off;
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	w_cnt = ((len*8)/ 32) + (((len*8) % 32 )? 1 :0 );// round to supperior
	v.format = vpiVectorVal;
	v.value.vector = calloc(w_cnt, sizeof(s_vpi_vecval));
	for (size_t i = 0; i < w_cnt; i++){
		v.value.vector[i].aval = 0;
	}	
	
	for (size_t i = 0; i < w_cnt*4; i++){
		off = (i%4)*8;
		if ( i < len ){
			v.value.vector[i/4].aval |= (PLI_INT32) ( 0x000000ff & (uint32_t)arr[i] ) << off ;	
			v.value.vector[i/4].bval |= ((PLI_INT32)0x00  ) << ((i%4)*8);
		}else{
			v.value.vector[i/4].aval |= ((PLI_INT32)0xff) << ((i%4)*8);	
			v.value.vector[i/4].bval |= ((PLI_INT32)0xff) << ((i%4)*8);	
		}
	}
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}
