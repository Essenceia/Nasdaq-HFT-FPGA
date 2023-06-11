/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License.
 *
 * This code is provided "as is" without any express or implied warranties. */

#include "moldudp64.h"
#define _BSD_SOURCE             /* See feature_test_macros(7) */
#include <endian.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

moldudp64_s * moldudp64_alloc(){
	moldudp64_s * p = NULL;
	p = ( moldudp64_s *) malloc(sizeof(moldudp64_s));
	memset(p, 0, sizeof(moldudp64_s));
	return p;
}

void moldudp64_add_msg(moldudp64_s *p, void *msg_data, size_t msg_len){
	uint16_t cnt = p->cnt;
	assert( cnt < MOLDUDP64_MSG_CNT_MAX );
	
	// resize msg, add 1
	p->msg[cnt] = (moldudp64_msg_s*) malloc(sizeof(moldudp64_msg_s)); 
	p->msg[cnt]->len  = (uint16_t) msg_len;
	p->msg[cnt]->data = (uint8_t*) malloc(sizeof(uint8_t)*msg_len);
	memcpy(p->msg[cnt]->data, msg_data, msg_len * sizeof(uint8_t));
	
	p->cnt+=1;
}

void moldudp64_clear(moldudp64_s *p){
	for ( uint16_t i = 0; i < p->cnt; i++){
		assert(p->msg[i]->data);
		free(p->msg[i]->data);
		free(p->msg[i]);
	}
	p->cnt = 0;
}
void moldudp64_free(moldudp64_s *p){
	if ( p->cnt != 0 ) moldudp64_clear(p);
	free(p);
}

size_t moldudp64_flatten(moldudp64_s *p, uint8_t **flat){
	uint16_t c;
	// big endian versions
	uint8_t  sid_be[10];
	uint64_t seq_be;
	uint16_t cnt_be;
	uint16_t len_be;	
	size_t s = offsetof(moldudp64_s, msg);
	// count size
	for ( c = 0; c < p->cnt; c++){
		s += sizeof(uint16_t) + p->msg[c]->len;	
	}
	assert(s > 0 );
	// allocate
	if ( *flat == NULL ){
		*flat = ( uint8_t *) malloc( sizeof(uint8_t) * s );
	}else{ 
		*flat = realloc(*flat, sizeof(uint8_t) * s);
	}
	assert(*flat);
	assert(s);
	// reset offset
	s = 0;
	// switch from default endian to big endian 
	for ( int  l = 0, h = sizeof(p->sid)-1 ; l < h ; l++, h-- ){
		sid_be[h] = p->sid[l];
		sid_be[l] = p->sid[h];
	}
	// copy memory
	memcpy(*flat+s, sid_be, sizeof(sid_be));
	s += sizeof(sid_be);
	seq_be =htobe64( p->seq ); 
	memcpy(*flat+s, &seq_be, sizeof(uint64_t));
	s+= sizeof(seq_be);
	cnt_be =htobe16( p->cnt ); 
	memcpy(*flat+s, &cnt_be, sizeof(uint16_t));
	s += sizeof(cnt_be);
	
	for( c = 0; c < p->cnt; c++ ){
		len_be = htobe16(p->msg[c]->len);
		memcpy(*flat+s, &len_be, sizeof(uint16_t));
		s += sizeof(len_be);
		memcpy(*flat+s, p->msg[c]->data, sizeof(uint8_t) * p->msg[c]->len);
		s+= p->msg[c]->len;
	}
	return s;
}

void moldudp64_set_ids(moldudp64_s* p,const uint8_t sid[10],const uint64_t seq){
	memcpy(&p->sid, sid, sizeof(uint8_t)*10);
	p->seq = seq;
}

void moldudp64_print(const moldudp64_s *p){
	printf("sid 0x");
	for	( int i = sizeof(p->sid); i >= 0; i--){
		printf("%02x",p->sid[i]);
	}
	printf("\nseq 0x%016lx\n", p->seq);
	printf("cnt %d",p->cnt);
	for( int c = 0; c < p->cnt; c++){
		printf("\n	len %d\n	",p->msg[c]->len);
		for( int l=p->msg[c]->len; l>= 0; l--)
			printf("%02x",p->msg[c]->data[l]);
	}
	printf("\n");
}


