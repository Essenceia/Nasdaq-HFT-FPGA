#ifndef TV_H
#define TV_H

/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 


#include "moldudp64.h"
#include "tb_itch.h"
#include <stdio.h>

#define MOLD_INIT_SID { 'a', 0xdd, 0xcc, 0xbb, 0xaa, 0x99, 0x88, 0x77, 0x66, 0x55 }
#define MOLD_INIT_SEQ 0xDEADBEAF0000AAAA 

typedef struct{
	FILE *           fptr;
	moldudp64_s     *mold_s;
	uint8_t         *flat;
	size_t           flat_l;
	size_t           flat_idx;
	tv_itch5_fifo_t *itch_fifo_s;
}tv_t;

tv_t * tv_alloc(const char * path);

void tv_create_packet(tv_t * t,size_t itch_n);

uint64_t tv_axis_get_next_64b(tv_t* t, uint8_t *mask, uint8_t *last);

bool tv_axis_has_data(tv_t *t);

void tv_free(tv_t * t);
#endif // TV_H
