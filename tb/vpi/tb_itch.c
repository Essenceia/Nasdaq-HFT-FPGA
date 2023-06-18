#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "tb_itch.h"
#include "tb_utils.h"

/*
 * Construct and return an itch fifo.
 */
tv_itch5_fifo_t *tb_itch_fifo_alloc(
	void
)
{
	tv_itch5_fifo_t *fifo = malloc_(tv_itch5_fifo_t);
	slisth_init(&fifo->elems);
	return fifo;
}

/*
 * Delete @fifo.
 */
void tb_itch_fifo_free(
	tv_itch5_fifo_t *fifo
)
{
	assert(fifo);
	slist *nod = 0;
	while((nod = slisth_pull(&fifo->elems))) {
		assert(nod);
		tv_itch5_fifo_elem_t *elem = cntof(nod, tv_itch5_fifo_elem_t, elems);
		free(elem->d);
		free(elem);
	}
	free(fifo);
}

/*
 * Construct and push an element in @fifo.
 */
void tb_itch_fifo_push(
	tv_itch5_fifo_t *fifo,
	tv_itch5_s *new,
	uint8_t debug_id[18]
)
{
	assert(fifo);
	tv_itch5_fifo_elem_t *elem = malloc_(tv_itch5_fifo_elem_t);
	elem->d = new;
	memcpy(elem->debug_id, debug_id, sizeof(uint8_t) * 18);
	slisth_push(&fifo->elems, &elem->elems);
	#if 0
	//#ifdef DEBUG
	printf("Itch fifo push :\n");
	tb_itch_print_fifo(fifo);
	#endif
}

/*
 * If @fifo is not empty, pop an element and return it.
 * Otherwise, return 0.
 */
tv_itch5_s* tb_itch_fifo_pop(
	tv_itch5_fifo_t *fifo,
	uint8_t debug_id[18]
)
{

	/* Pop. */
	assert(fifo);
	assert(debug_id);
	slist *nod = slisth_pull(&fifo->elems);
	if (!nod) return NULL;
	tv_itch5_fifo_elem_t *pop = cntof(nod, tv_itch5_fifo_elem_t, elems);
	assert(!pop->elems.next);

	/* Read data, delete @pop. */	
	memcpy(debug_id, pop->debug_id, sizeof(uint8_t) * 18 );
	tv_itch5_s *ret = pop->d;
	free(pop);
	#ifdef DEBUG
	printf("ITCH pop, debug id : 0x");
	for(int i = 17; i--;)
		printf("%02hhx",debug_id[i]);
	printf("\n");
	printf("Itch poped structure :\n");
	print_tv_itch5(ret);
	
	// print fifo
	tb_itch_print_fifo(fifo);
	#endif	

	/* Complete. */	
	return ret;

}

/*
 * Print a descriptor for all elements of @fifo.
 */
void tb_itch_print_fifo(
	tv_itch5_fifo_t *fifo
)
{
	if (!fifo) return;
	printf("Fifo :\n");
	int e = 0;
	slist *nod = fifo->elems.read;
	while (nod) {
		tv_itch5_fifo_elem_t *elem = cntof(nod, tv_itch5_fifo_elem_t, elems);
		uint8_t db_id[18];
		memcpy(db_id, elem->debug_id, sizeof(uint8_t) * 18 );
		printf("- elem %d debug id 0x",e);
		for(int i = 17; i--;)printf("%02hhx",db_id[i]); 
		printf("\n");
		nod = nod->next;
	}
	printf("\n");
}

tv_itch5_s *tb_itch_create_struct(const uint8_t *data, size_t data_len){
	tv_itch5_s *rptr;
	uint8_t msg_type;
	uint8_t *data_inner;
	assert(data != NULL);
	assert(data_len > 0);
	msg_type = data[0];
	rptr = (tv_itch5_s*) calloc( 1, sizeof(tv_itch5_s));
	data_inner = (uint8_t *) (data + sizeof(char_t));
	fill_tv_itch5((char)msg_type, data_inner, data_len-1, rptr);
	#if 0
	//#ifdef DEBUG
	printf("Data used to create itch struct :\n");
	for(int i = (int)data_len-2; i>-1; i--){
		printf("byte %02d %02hhx (%c)\n", i, data_inner[i], isalpha(data_inner[i])? data_inner[i] : ' ' );
	}
	print_tv_itch5( rptr);
	#endif
	return rptr;
}


void tb_itch_put_struct(vpiHandle argv, tv_itch5_s *itch_s){
	#include "gen/tb_itch_msg_put_head.h"
	#include "gen/tb_itch_msg_put_inner.h"
}
