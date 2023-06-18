#ifndef TB_ITCH_H
#define TB_ITCH_H

#include <vpi_user.h>
#include "itch_s.h"
#include "itch.h"

/*********
 * Utils *
 *********/

/*
 * Evaluate to the address located @offset (relative) bytes after pointer @ptr.
 */
#define psum(ptr, offset)\
    ((void *) (((uint8_t *) (ptr)) + ((size_t) (offset))))

/*
 * Evaluate to a bytewise subtraction between a and b.
 */
#define psub(a, b)\
     ((size_t) (((uint8_t *) (a)) - ((uint8_t *) (b))))

/*
 * Evaluate to the offset of member @member in structure @type.
 */
#define offof(type, member) ((size_t) (&(((type *) 0)->member)))

/*
 * Evaluate to the difference between offsets of member0 and member1 in structure @type.
 */
#define offbtw(type, member0, member1) (offof(type, member0) - offof(type, member1))

/*
 * Evaluate to the ref of the object of type @type that contains a member
 * @member whose location is @ptr.
 */
#define cntof(ptr, type, member)\
    ((type *) (psum(ptr, - offof(type, member))))
#define cntof_def(type, var, ptr, member) \
type *var = cntof(ptr, type, member);

/*
 * If @ptr if non-null, evaluate to the ref of the object of type @type that contains a member
 * @member whose location is @ptr.
 * Otherwise, evaluate to 0.
 */
#define cntofs(ptr, type, member)\
    ({type *p = cntof(ptr, type, member); ((p) ? p : (type *) 0);})

/*
 * Evaluate to 1 if @ptr points to a valid element of the array of @nb
 * elements of size @elsize starting at @start.
 */
#define iselof(ptr, start, nb, size) (\
	((void *) (start) <= (void *) (ptr)) && \
	((void *) (ptr) < psum((void *) start, nb * size)) && \
	(!(psub(ptr, start) % size)) \
)

#define malloc_(x) (x *) malloc(sizeof(x))

/*********
 * Slist *
 *********/

typedef struct slist slist;
typedef struct slisth slisth;

/*
 * Slist node.
 */
struct slist {

	/* Next. */
	slist *next;

};

/*
 * Slist head.
 */
struct slisth {

	/* Write (can only write). */
	slist *write;

	/* Read (can read and write). */
	slist *read;

};

/*************
 * Slist ops *
 *************/

/*
 * Link @a -> @b.
 */
static inline void slist_link(
	slist *a,
	slist *b
) {a->next = b;}

/*
 * Unlink @a -> @b.
 */
static inline void slist_unlink(
	slist *a,
	slist *b
) {
	assert(a->next == b);
	a->next = 0;
}

/*
 * Insert @b element after @a.
 */
static inline void slist_insert(
	slist *a,
	slist *b
	
)
{
	slist *c = a->next;
	a->next = b;
	b->next = c;
}

/*
 * Unlink @a and its successor, return the successor.
 */
static inline slist *slist_pop(
	slist *a
) {
	slist *b = a->next;
	a->next = 0;
	return b;
}

/**************
 * Slisth ops *
 **************/

/*
 * Initialize @head.
 */
static inline void slisth_init(
	slisth *head
)
{
	head->read = 0;
	head->write = 0;
}

/*
 * Push @a in @head.
 */
static inline void slisth_push(
	slisth *head,
	slist *a
)
{
	assert((!head->read) == (!head->write));
	slist *write = head->write;
	if (write) write->next = a;
	a->next = 0;
	head->write = a;
	if (!head->read) head->read = a;
}

/*
 * If @head has at least one node, pull the node at read position
 * and return it.
 * Otherwise, return 0.
 */
static inline slist *slisth_pull(
	slisth *head
)
{
	assert((!head->read) == (!head->write));
	slist *a = head->read;
	if (!a) return 0;
	head->read = a->next;
	if (!head->read) head->write = 0;
	a->next = 0;
	return a;
}
	

/*
 * Unpull @a into @slisth.
 * It will become the next element to be pulled.
 */
static inline void slisth_unpull(
	slisth *head,
	slist *a
)
{
	assert((!head->read) == (!head->write));
	slist *read = head->read;
	a->next = read;
	head->read = a;
	if (!head->write) head->read = a;
}

/*******
 * Rem *
 *******/

/*
 * Itch structre fifo, simply linked list.
 */
typedef struct{

	/* Elements of the same fifo sorted by recency. */
	slist elems;

	/* Debug id. */
	uint8_t debug_id[18];

	/* Itch struct. */
	tv_itch5_s *d;

} tv_itch5_fifo_elem_t;

typedef struct{
	slisth elems;
} tv_itch5_fifo_t;

/*
 * Construct and return an itch fifo.
 */
tv_itch5_fifo_t * tb_itch_fifo_alloc(
	void
);

/*
 * Delete @fifo.
 */
void tb_itch_fifo_free(
	tv_itch5_fifo_t *fifo
);

/*
 * Construct and push an element in @fifo.
 */
void tb_itch_fifo_push(
	tv_itch5_fifo_t *fifo,
	tv_itch5_s *new,
	uint8_t debug_id[18]
);

/*
 * If @fifo is not empty, pop an element and return it.
 * Otherwise, return 0.
 */
tv_itch5_s* tb_itch_fifo_pop(
	tv_itch5_fifo_t *fifo,
	uint8_t debug_id[18]
);

/*
 * Print a descriptor for all elements of @fifo.
 */
void tb_itch_print_fifo(
	tv_itch5_fifo_t *fifo
);

void tb_itch_put_struct(vpiHandle argv, tv_itch5_s *itch_s);

tv_itch5_s *tb_itch_create_struct(const uint8_t *data, size_t data_len);

#endif // TB_ITCH_H

