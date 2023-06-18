/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License.
 *
 * This code is provided "as is" without any express or implied warranties. */
#include "axis.h"
#include <assert.h>
#include <string.h>
#include <math.h>
uint64_t axis_get_next_64b(const uint8_t *flat, size_t *idx, const size_t len, uint8_t *mask){
	uint64_t buff = 0;
	uint8_t new_mask = 0;
	size_t max_idx = len-1;
	size_t nxt_idx = *idx+8;
	size_t keep = ( max_idx <= nxt_idx)?
				 ( max_idx == nxt_idx )? 8 : max_idx+1 - *idx 
				: 8;
	#ifdef DEBUG
	size_t min_idx = ( max_idx < nxt_idx)? max_idx : nxt_idx;
	printf("min_idx %ld idx %ld nxt_idx %ld max_idx %ld keep %ld\n",
		     min_idx, *idx, nxt_idx,  max_idx, keep);
	#endif	
	assert(flat);
	assert( keep > 0);
	
	
	memcpy(&buff, flat+*idx, sizeof(uint8_t)*keep);

	#ifdef DEBUG
	printf("keep %ld\n", keep);
	#endif
	
	for( size_t i=0; i < keep; i++){
		new_mask |= (uint8_t)(0x01 << i);
	}	

	*idx = nxt_idx;	
	*mask = new_mask;
	#ifdef DEBUG
	printf("new idx %ld new mask %02hhx mask %02hhx\n\n", *idx, new_mask,  *mask);
	#endif		

	return buff; 
}
 
void axis_send_64b(const uint64_t payload, const uint8_t mask, 
	uint8_t *tvalid, uint8_t *tkeep, uint8_t *tready, uint64_t*tdata){
	if ( *tready ){
		*tvalid = 1;
		*tkeep = mask;
		*tdata = payload;
	}
	*tvalid = 0;
}
