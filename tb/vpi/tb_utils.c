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

void tb_vpi_logic_put_1b(vpiHandle argv, uint8_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiScalarVal;
	v.value.scalar = var ? vpi1 : vpi0;
	vpi_put_value(h, &v, 0, vpiNoDelay);
}
void tb_vpi_logic_put_32b(vpiHandle argv, uint32_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(1, sizeof(s_vpi_vecval));
	v.value.vector[0].aval = var;
	v.value.vector[0].bval = 0;
	vpi_put_value(h, &v, 0, vpiNoDelay);
	free(v.value.vector);	
}

void tb_vpi_logic_put_64b(vpiHandle argv, uint64_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(2, sizeof(s_vpi_vecval));
	v.value.vector[0].aval =(uint32_t) var; //32 lsb 
	v.value.vector[0].bval = 0;
	v.value.vector[1].aval =(uint32_t) var >> 32; //32 msb 
	v.value.vector[1].bval = 0;
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}

void tb_vpi_logic_put_48b(vpiHandle argv, uint64_t var){
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	v.format = vpiVectorVal;
	v.value.vector = calloc(2, sizeof(s_vpi_vecval));
	/* bit encoding: ab: 00=0, 10=1, 11=X, 01=Z 
 	*  set 16 msb to X, keep only 48 lsb */
	v.value.vector[0].aval =(uint32_t) var; //32 lsb 
	v.value.vector[0].bval = 0;
	v.value.vector[1].aval =(uint32_t) 0xffff0000 | ( var >> 32 ); //32 msb 
	v.value.vector[1].bval = 0xffff0000;
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}


void _tb_vpi_logic_put_8b_var_arr(vpiHandle argv, uint8_t *arr, size_t len){
	size_t w_cnt; // word count, vpi vector val elems are only of 32b wide each
	vpiHandle h;
	s_vpi_value v;
	h = vpi_scan(argv);
	assert(h);
	w_cnt = ( len + 31 ) % 32;// round to supperior
	v.format = vpiVectorVal;
	v.value.vector = calloc(2, sizeof(s_vpi_vecval)*w_cnt);
	for (int i = 0; i < w_cnt * 4 ; i++){
		if ( i < len ){
			v.value.vector[i/4].aval |= ((uint32_t)arr[i]) << i%4;	
			v.value.vector[i/4].bval |= ((uint32_t)0x00  ) << i%4;	
		}else{
			v.value.vector[i/4].aval |= ((uint32_t)0xff) << i%4;	
			v.value.vector[i/4].bval |= ((uint32_t)0xff) << i%4;	
		}
	}
	vpi_put_value(h, &v, 0, vpiNoDelay);	
	free(v.value.vector);	
}
