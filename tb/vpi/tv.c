/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#include "tv.h"
#include <stdlib.h>
#include <assert.h>
#include "file.h"
#include "axis.h"
tv_t * tv_alloc(const char *path){
	tv_t *tv;
	tv = (tv_t *) malloc( sizeof(tv_t));
	assert(tv);
	tv->mold_s   = moldudp64_alloc();
	assert(tv->mold_s);
	tv->flat_l   = 0; 
	tv->flat_idx = 0;
	tv->fptr = fopen( path, "rb");
	assert(tv->fptr);
	tv->flat = NULL;
	tv->itch_fifo_s = tb_itch_fifo_alloc();
	return tv; 
}

void tv_create_packet(tv_t * t, size_t itch_n){
	size_t r = 0; // read size
	size_t n; // number of messages read
	uint8_t buff[ITCH_MSG_MAX_LEN];		
	uint8_t sid[10] = { 'a', 0xdd, 0xcc, 0xbb, 0xaa,
					    0x99, 0x88, 0x77, 0x66, 0x55 };// 0:9
	uint64_t seq = 0xDEADBEAF0000AAAA;

	moldudp64_set_ids(t->mold_s, sid, seq); 
	// read itch messages from file
	for( n = 0; n < itch_n ; n++){
		r = get_next_bin_msg(t->fptr, buff, ITCH_MSG_MAX_LEN);
		if ( r == 0 )break;
		// add it's contents to mold struct
		moldudp64_add_msg(t->mold_s, buff, r);
		tb_itch_fifo_push(t->itch_fifo_s, tb_itch_create_struct(buff, r)); 
	}
	r =	moldudp64_flatten(t->mold_s, &t->flat);
	assert(t->flat);
	t->flat_l = r;
	t->flat_idx = 0;
	moldudp64_clear( t-> mold_s );
}

uint64_t tv_axis_get_next_64b(tv_t* t, uint8_t *tkeep){
	uint64_t tdata;

	if ( axis_msg_finished(&t->flat_idx, t->flat_l ) ){
		#ifdef DEBUG
		printf("Axis message finished, creating new message\n");
		#endif
		tv_create_packet( t, 1 );

	}
	tdata = axis_get_next_64b(t->flat, &t->flat_idx , t->flat_l, tkeep);
	return tdata;	
}

void tv_free(tv_t * t)
{
	moldudp64_free(t->mold_s);
	tb_itch_fifo_free(t->itch_fifo_s);
	fclose(t->fptr);
	free(t->flat);
}
