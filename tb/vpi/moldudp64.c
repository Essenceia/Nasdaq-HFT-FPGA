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
#include <ctype.h>

moldudp64_s * moldudp64_alloc(){
	moldudp64_s * p = NULL;
	p = ( moldudp64_s *) malloc(sizeof(moldudp64_s));
	memset(p, 0, sizeof(moldudp64_s));
	return p;
}

void moldudp64_add_msg(
	moldudp64_s *p,
	void *msg_data,
	size_t msg_len
)
{

	/* Reserve a message element. */
	const uint16_t cnt = p->cnt++;
	assert(cnt < MOLDUDP64_MSG_CNT_MAX);
	assert(msg_len);

	/* Allocate a message buffer, copy. */
	assert(!p->msg[cnt]);
	assert(msg_len <= (uint16_t) -1);
	p->msg[cnt] = malloc_(moldudp64_msg_s); 
	p->msg[cnt]->len  = (uint16_t) msg_len;
	p->msg[cnt]->data = (uint8_t *) malloc(sizeof(uint8_t) * msg_len);
	memcpy(p->msg[cnt]->data, msg_data, msg_len * sizeof(uint8_t));

	/* Debug. */
	mdbg(msg_data, p->msg[cnt]->data, msg_len, "Copied mold message %d (%p).\n", cnt, p->msg[cnt]->data);

}

void moldudp64_clear(moldudp64_s *p){
	for ( uint16_t i = 0; i < p->cnt; i++){
		assert(p->msg[i]->data);
		free(p->msg[i]->data);
		free(p->msg[i]);
		p->msg[i] = 0;
	}
	// update seq
	assert(!__builtin_uaddl_overflow(p->seq, (uint64_t)p->cnt, &p->seq )); 
	p->cnt = 0;
}
void moldudp64_free(moldudp64_s *p){
	if ( p->cnt != 0 ) moldudp64_clear(p);
	free(p);
}

size_t moldudp64_flatten(
	moldudp64_s *p,
	uint8_t **flat
)
{
	// big endian versions
	uint8_t  sid_be[10];
	uint64_t seq_be;
	uint16_t cnt_be;
	uint16_t len_be;	
	size_t pkt_size = 20;
	assert(offsetof(moldudp64_s, msg) == 20);
	assert(sizeof(sid_be) == 10);
	assert(sizeof(seq_be) == 8);
	assert(sizeof(cnt_be) == 2);
	assert(sizeof(len_be) == 2);

	#ifdef DEBUG
	size_t tmp_s = 0;
	moldudp64_print(p);
	#endif

	info("offset size %ld\n", pkt_size);

	/* For each message, add 2 bytes for the header and
	 * the message length. */
	for (uint16_t msg_cnt = 0; msg_cnt < p->cnt; msg_cnt++){
		pkt_size += sizeof(uint16_t);
		info("msg '%d' header size '2' -> size = '%ld'\n", msg_cnt, pkt_size);
		pkt_size += p->msg[msg_cnt]->len;
		assert(p->msg[msg_cnt]->len);
		info("msg '%d' size '%d', -> size '%ld'\n", msg_cnt, p->msg[msg_cnt]->len, pkt_size);
	}

	/* Update the destination packet size. */
	if (*flat != NULL) free(*flat);
	void *dst = *flat = (uint8_t *) malloc(sizeof(uint8_t) * pkt_size );
	assert(dst);

	// switch from default endian to big endian 
	for ( int  l = 0, h = sizeof(p->sid)-1 ; l < h ; l++, h-- ){
		sid_be[h] = p->sid[l];
		sid_be[l] = p->sid[h];
	}
	seq_be = htobe64(p->seq); 
	cnt_be = htobe16(p->cnt);


	/* Copy utilities. */
	#define COPY_VAL(x) { \
		memcpy(dst + pkt_cnt, &x, sizeof(x)); \
		pkt_cnt += sizeof(x); \
	}
	#define COPY_ARR(x) { \
		memcpy(dst + pkt_cnt, x, sizeof(x)); \
		pkt_cnt += sizeof(x); \
	}
	#define COPY_PTR(x, len) { \
		memcpy(dst + pkt_cnt, x, len * sizeof(*x)); \
		pkt_cnt += len * sizeof(*x); \
	}



	/* Copy the header. */
	size_t pkt_cnt = 0;
	COPY_ARR(sid_be);
		//memcpy(*flat+pkt_cnt, sid_be, sizeof(uint8_t)*10);
		//pkt_cnt += sizeof(sid_be);
	COPY_VAL(seq_be);
		//memcpy(*flat+pkt_cnt, &seq_be, sizeof(uint8_t)*8);
		//pkt_cnt+= sizeof(seq_be);
	COPY_VAL(cnt_be);
		//memcpy(*flat + pkt_cnt, &cnt_be, sizeof(uint8_t)*2);
		//pkt_cnt += sizeof(cnt_be);
	
	/* Copy each message. */
	for (uint16_t msg_cnt = 0; msg_cnt < p->cnt; msg_cnt++){

		mlog(p->msg[msg_cnt]->data, p->msg[msg_cnt]->len, "Read mold message %d (%p).\n", msg_cnt, p->msg[msg_cnt]->data);

		/* Convert endianness. */
		uint16_t msg_len_be;	
		assert(sizeof(msg_len_be) == 2);
		msg_len_be = htobe16(p->msg[msg_cnt]->len);

		/* Copy data. */
		COPY_VAL(msg_len_be);
			//memcpy(*flat +pkt_cnt, &msg_len_be, sizeof(uint8_t)*2);
			//pkt_cnt += sizeof(uint16_t);
		info("msg %d msg_len_be_off %ld\n", msg_cnt, pkt_cnt);
		
		/* Save. */
		#ifdef DEBUG
		tmp_s = pkt_cnt;
		#endif	

		COPY_PTR(p->msg[msg_cnt]->data, p->msg[msg_cnt]->len);
			//memcpy(*flat + pkt_cnt, p->msg[msg_cnt]->data, sizeof(uint8_t) * p->msg[msg_cnt]->len);
			//pkt_cnt += p->msg[msg_cnt]->len;
		mdbg(dst + tmp_s, p->msg[msg_cnt]->data, p->msg[msg_cnt]->len, "Flattened mold message %d (%p).\n", msg_cnt, p->msg[msg_cnt]->data);

		#ifdef DEBUG
		uint8_t a;
		uint8_t debug_id[18];
		
		moldudp64_get_debug_id(p->sid, p->seq, msg_cnt, &debug_id);
	
		info("flatten mold msg, raw data, debug_id 0x");
		for(int i=17; i > -1; i--)info("%02hhx", debug_id[i]);
		info("\n");
		for(int i =(int)(p->msg[msg_cnt]->len)-1; i > -1; i--){
			a = p->msg[msg_cnt]->data[i];
			info("byte %02d %02hhx (%c)\n", i, a, isalpha(a)? a : ' ');
		}
		info("\n");
		
		info("total data %ld\nwritten data :\n",pkt_cnt);
		for(int i =(int)(p->msg[msg_cnt]->len)-1; i > -1; i--){
			a = *(*flat + tmp_s +(size_t)i );
			info("byte %02d %02hhx (%c)\n", i, a, isalpha(a)? a : ' ');
		}
		info("\n");info("size %ld\n", pkt_cnt);
		#endif	

	}
	assert(pkt_cnt == pkt_size);
	return pkt_size;
}

void moldudp64_set_ids(moldudp64_s* p,const uint8_t sid[10],const uint64_t seq){
	memcpy(&p->sid, sid, sizeof(uint8_t)*10);
	p->seq = seq;
}

void moldudp64_print(const moldudp64_s *p){
	uint8_t debug_id[18];
	printf("sid 0x");
	for	( int i = sizeof(p->sid); i >= 0; i--){
		printf("%02x",p->sid[i]);
	}
	printf("\nseq 0x%016lx\n", p->seq);
	printf("cnt %d 0x%04x",p->cnt, p->cnt);
	for( int c = 0; c < p->cnt; c++){
		printf("\n	len %d	0x",p->msg[c]->len);
		moldudp64_get_debug_id(p->sid, p->seq, c, &debug_id);
		for(int i = 17; i > -1; i--)printf("%02hhx", debug_id[i]);
		printf("\n    ");
		for( int l=p->msg[c]->len; l>= 0; l--)
			printf("%02x",p->msg[c]->data[l]);
		printf("\n");
		
	}
	printf("\n");
}

void moldudp64_get_ids(moldudp64_s *p, uint16_t msg_cnt_offset, uint8_t *sid[10], uint64_t *seq){
	assert(p);
	assert(sid);
	assert(seq);
	// no overflow - should have sent an end of session, updated sid and 
	// reset seq to 0 before we hit and overflow
	assert(!__builtin_uaddl_overflow(p->seq, (uint64_t) msg_cnt_offset, seq )); 
	memcpy(*sid, p->sid, sizeof(uint8_t)*10);
}
void moldudp64_get_debug_id(const uint8_t sid[10], const uint64_t seq, const uint16_t msg_cnt_offset, uint8_t debug_id[18]){
	// debug id formal { sid , seq } ( little endian )
	uint64_t seq_inc;
	assert(!__builtin_uaddl_overflow( seq, (uint64_t) msg_cnt_offset, &seq_inc )); 
	memcpy(debug_id, &seq_inc, sizeof(uint64_t));
	memcpy(debug_id+sizeof(uint64_t), sid, sizeof(uint8_t)*10);
}

