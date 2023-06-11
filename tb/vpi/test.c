/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#ifndef TEST_H
#define TEST_H
#include "moldudp64.h"
#include "file.h"
#include "tv.h"

#include <stdlib.h>

#ifndef RAND_SEED
#define RAND_SEED 1
#endif // RAND_SEED

#define AXI_PAYLOAD 60
int main(){
	uint64_t d;
	uint8_t k;
	tv_t *tv_s = tv_alloc("../12302019.NASDAQ_ITCH50");
	tv_create_packet(tv_s, 1 );
	// read file content to struct
	for( int c = 0; c < AXI_PAYLOAD; c++){
		d = tv_axis_get_next_64b(tv_s, &k);
		printf("data %#016lx, mask %2x\n", d, k);
	}
	tv_free(tv_s);
	free(tv_s);
	return 0;
}
#endif // TEST_H
