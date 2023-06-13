#include "tb_itch.h"
#include <stdlib.h>
#include <assert.h>
#include "tb_utils.h"
// fifo 
tv_itch5_fifo_t * tb_itch_fifo_alloc(){
	tv_itch5_fifo_t *rptr;
	rptr = (tv_itch5_fifo_t*) malloc(sizeof(tv_itch5_fifo_t));
	rptr->r=NULL;
	rptr->w=NULL;
	return rptr;
}

void tb_itch_fifo_push(tv_itch5_fifo_t *fifo, tv_itch5_s *new){
	tv_itch5_fifo_elem_t *wrap; // wrapper
	assert(fifo);
	wrap = (tv_itch5_fifo_elem_t *) malloc( sizeof(tv_itch5_fifo_elem_t));
	wrap->d = new;
	wrap->n = NULL;
	if ( fifo->w != NULL){
		fifo->w->n = wrap;
	}
	fifo->w = wrap->n;
}
tv_itch5_s* tb_itch_fifo_pop(tv_itch5_fifo_t *fifo){
	tv_itch5_fifo_elem_t *pop;
	tv_itch5_s *rptr;
	assert(fifo);
	pop = fifo->r;
	if ( pop == NULL )return NULL;
	fifo->r = pop->n;
	rptr = pop->d;
	free(pop);
	return rptr;
}
void tb_itch_fifo_free(tv_itch5_fifo_t *fifo){
	tv_itch5_fifo_elem_t *elem;
	assert(fifo);
	while( fifo->r != NULL){
		elem = fifo->r->n;
		free(fifo->r->d);
		free(fifo->r);
		fifo->r = elem;
	}
	free(fifo);
}

tv_itch5_s *tb_itch_create_struct(uint8_t *data, size_t data_len){
	tv_itch5_s *rptr;
	uint8_t msg_type;
	assert(data != NULL);
	assert(data_len > 0);
	msg_type = data[0];
	rptr = (tv_itch5_s*) malloc( sizeof(tv_itch5_s));
	fill_tv_itch5((char)msg_type, data+1, data_len-1, rptr);
	return rptr;
}


void tb_itch_put_struct(vpiHandle argv, tv_itch5_s *itch_s){
	#include "gen/tb_itch_msg_put_head.h"
	#include "gen/tb_itch_msg_put_inner.h"
}
