/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License.
 *
 * This code is provided "as is" without any express or implied warranties. */

#include "moldudp64.h"

moldudp64_s * moldudp64_alloc(){
	moldudp64_s * p = NULL;
	p = ( moldudp64_s *) malloc(sizeof(moldudp64_s));
	memset(p, 0, sizeof(moldudp64_s));
	return p;
}


void moldudp64_add_msg(moldudp64_s *p, void *msg_data, size_t msg_len){
	uint16_t cnt;
	assert( p->cnt < MOLDUDP64_MSG_CNT_MAX );
	
	// resize msg, add 1
	cnt = p->cnt+1;
	p->msg[cnt] = (moldudp64_msg_s*) malloc(sizeof(moldudp64_msg_s)); 
	p->cnt = cnt;
	p->msg[cnt]->len  = (uint16_t) msg_len;
	p->msg[cnt]->data = (uint8_t*) malloc(sizeof(uint8_t)*msg_len);
}

void moldudp64_clear(moldudp64_s *p){
	for ( uint16_t i = 0; i < p->cnt; i++){
		free(p->msg[i]->data);
		free(p->msg[i]);
	}
	p->cnt = 0;
}

int moldudp64_free(moldudp64_s *p){
	if ( p->cnt != 0 ) moldudp64_clear(p);
	free(p);
}

size_t moldudp64_flatten(moldudp64_s *p, uint8_t *flat){
	size_t off = offsetof(msg, moldudp64_s);
	size_t s = off;
	uint16_t c;
	// count size
	for ( c = 0; c < p->cnt; c++){
		s += sizeof(uint16_t) + p->msg[c]->len;	
	}
	// allocate
	flat = ( uint8_t *) malloc( sizeof(uint8_t) * s );
	// copy memory 
	memcpy(flat, p, off);
	s = off;
	for( c = 0; c < p->cnt; c++ ){
		memcpy(flat+s; p->msg[c]; sizeof(uint16_t));
		s += sizeof(uint16_t);
		memcpy(flat+s; p->msg[c]->data; sizeof(uint8_t) * p->msg[c]->len);
	}
	return s;
}


