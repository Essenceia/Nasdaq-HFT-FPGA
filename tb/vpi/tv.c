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
	moldudp64_set_ids(tv->mold_s,((uint8_t [])MOLD_INIT_SID ), MOLD_INIT_SEQ); 
	tv->flat_l   = 0; 
	tv->flat_idx = 0;
	tv->fptr = fopen( path, "rb");
	assert(tv->fptr);
	tv->flat = NULL;
	tv->itch_fifo_s = tb_itch_fifo_alloc();
	return tv; 
}

/*
 * TODO DOC LOL.
 */
void tv_create_packet(tv_t *t, size_t itch_n) {
	// read itch messages from file
	#ifdef DEBUG
	printf("\ntv_create_packet cnt %ld\n\n", itch_n);
	#endif
	for(size_t msg_cnt = 0; msg_cnt < itch_n; msg_cnt++){

		//mlog("Reading message %ld/%ld \n\n", msg_cnt, itch_n);

		/* Read an itch message. */
		uint8_t buff[ITCH_MSG_MAX_LEN + 1];		
		buff[ITCH_MSG_MAX_LEN] = 0xde;	
		size_t msg_len = get_next_bin_msg(t->fptr, buff, ITCH_MSG_MAX_LEN);
		if (msg_len ==  0) {
			fprintf(stderr, "No new message to read\n");
			break;
		}
		assert(buff[ITCH_MSG_MAX_LEN] == 0xde);
		assert(msg_len <= ITCH_MSG_MAX_LEN);
		
		/* Debug info. */
		mlog(buff, msg_len, "Read message '%ld'.\n", msg_cnt);
		
		/* Copy the read message at the end of the mold struct. */
		moldudp64_add_msg(t->mold_s, buff, msg_len);
		assert(buff[ITCH_MSG_MAX_LEN] == 0xde);
	
		// create itch structure with debug id
		uint8_t tmp_debug_id[18];
		moldudp64_get_debug_id(t->mold_s->sid, t->mold_s->seq, tmp_debug_id);
		#ifdef DEBUG
		//printf("Mold msg %ld at mold index %d debug id 0x", msg_cnt, t->mold_s->cnt);
		//for (int i=17; i > -1; i-- )printf("%02hhx", tmp_debug_id[i]);
		//printf("\n");
		#endif
		tb_itch_fifo_push(t->itch_fifo_s, tb_itch_create_struct(buff, msg_len), tmp_debug_id); 
	}

	size_t r = 0; // read size
	if(t->mold_s->cnt > 0) {
		info("\ntv_create_packet flatten called\n\n");
		r =	moldudp64_flatten(t->mold_s, &t->flat);
		assert(t->flat != NULL );
	}else{
		fprintf(stderr,"No mold message to put into packet \n");
		t->flat = NULL;
		r = 0;
	}
	t->flat_l = r;
	t->flat_idx = 0;
	moldudp64_clear( t-> mold_s );
	#ifdef DEBUG
	printf("tv_create_packet end, cnt %d\n", t->mold_s->cnt);
	#endif
	assert(t->mold_s->cnt == 0);	
}

uint64_t tv_axis_get_next_64b(
	tv_t* t, 
	uint8_t *tkeep, 
	uint8_t *tlast
)
{
	uint64_t tdata;
	assert(t);
	if ( axis_msg_finished(&t->flat_idx, t->flat_l ) ){
		#ifdef DEBUG
		printf("Axis message finished, creating new message\n");
		#endif
		tv_create_packet( t, 1 );

	}
	*tlast = axis_msg_last(&t->flat_idx, t->flat_l );
	assert(t->flat!= NULL );
	tdata = axis_get_next_64b(t->flat, &t->flat_idx , t->flat_l, tkeep);
	return tdata;	
}
bool tv_axis_has_data(tv_t* t){
	bool has_data;
	int  eof;
	bool msg_finished;
	bool flat_null; // the last entry in the bin file was invalid, eg : eof size 0 
	eof = feof(t->fptr);
	msg_finished = axis_msg_finished(&t->flat_idx, t->flat_l ); 
	flat_null = t->flat == NULL;
	has_data = !( (eof && msg_finished) || flat_null );
	if ( !has_data )
		 printf("TB : No more data to send to axis, end of file %d, axis msg finished %d flat null %d\n",
		 eof, msg_finished, flat_null);
	return has_data;
}

void tv_free(tv_t * t)
{
	moldudp64_free(t->mold_s);
	tb_itch_fifo_free(t->itch_fifo_s);
	fclose(t->fptr);
	free(t->flat);
}
