#ifndef TB_ITCH_H
#define TB_ITCH_H
#include <vpi_user.h>
#include "itch_s.h"
#include "itch.h"
/* Itch structre fifo, simply linked list */
typedef struct{
	void        *n;// next element 
	tv_itch5_s  *d;
}tv_itch5_fifo_elem_t;

typedef struct{
	tv_itch5_fifo_elem_t *r;  // read
	tv_itch5_fifo_elem_t *w; // write		
}tv_itch5_fifo_t;

tv_itch5_fifo_t * tb_itch_fifo_alloc();
void tb_itch_fifo_push(tv_itch5_fifo_t *fifo, tv_itch5_s *new);
// if empty return null ptr
tv_itch5_s* tb_itch_fifo_pop(tv_itch5_fifo_t *fifo);
void tb_itch_fifo_free(tv_itch5_fifo_t *fifo);

void tb_itch_put_struct(vpiHandle argv, tv_itch5_s *itch_s);

tv_itch5_s *tb_itch_create_struct(uint8_t *data, size_t data_len);
#endif // TB_ITCH_H

