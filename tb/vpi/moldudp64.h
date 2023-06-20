#ifndef MOLDUDP64_H
#define MOLDUDP64_H

/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License.
 *
 * This code is provided "as is" without any express or implied warranties. */

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "tb_config.h"

typedef struct __attribute__((__packed__)){
	uint16_t  len;
	uint8_t  *data;
}moldudp64_msg_s;

typedef struct __attribute__((__packed__)){
	uint8_t sid[10]; // session id
	uint64_t seq;	// sequence number
	uint16_t cnt;	// message count
	moldudp64_msg_s *msg[MOLDUDP64_MSG_CNT_MAX]; // messages 
} moldudp64_s;

moldudp64_s * moldudp64_alloc();

void moldudp64_add_msg(moldudp64_s *p, void *msg_data, size_t msg_len);
// free all alloced messages
void moldudp64_clear(moldudp64_s *p);

void moldudp64_free(moldudp64_s *p);

// flatten the structure into a byte array, applies correct endianness
// to flattened version
size_t moldudp64_flatten(moldudp64_s *p, uint8_t **flat);


void moldudp64_set_ids(moldudp64_s* p,const uint8_t sid[10],const uint64_t seq);

void moldudp64_print(const moldudp64_s *p);
// get the session id and sequence number for a given message 
void moldudp64_get_ids(moldudp64_s *p,uint16_t msg_cnt_offset,uint8_t *sid[10],uint64_t *seq); 

void moldudp64_get_debug_id(const uint8_t sid[10], const uint64_t seq, const uint16_t msg_cnt_offset, uint8_t debug_id[18]);

#define malloc_(x) (x *) malloc(sizeof(x))
typedef uint8_t u8;


#ifdef DEBUG
#define info(...) printf(__VA_ARGS__)
#else
#define info(...)
#endif
#endif // MOLDUDP64_H


/*
 * Abort if the contents @a and @b,
 * two blocks of size @nb differ.
 */
static inline void mcmp_(
	const char *a_name,
	const char *b_name,
	void *a,
	void *b,
	size_t nb
)
{
	uint8_t *x = a;
	uint8_t *y = b;
	for (size_t i = 0; i < nb; i++) {
		if (x[i] != y[i]) {
			printf("mcmp fail : ('%s'[%ld] = '%hhx') != ('%s'[%ld] = '%hhx').\n", a_name, i, x[i], b_name, i, y[i]);
			abort();
		}
	}
}
#define mcmp(a, b, nb) mcmp_(#a, #b, a, b, nb)

static inline void mlog_(
	const char *name_a,
	void *a,
	size_t nb
)
{
	uint8_t *x = a;
	printf("array of '%ld' bytes : '%s(%p)'.\n", nb, name_a, a);
	for(size_t i = 0; i < nb; i++) {
		uint8_t c = x[i];
		printf("- %02ld (%02hhx : %c)\n", i, c, isalpha(c) ? c : ' ');
	}
	printf("\n");
}

static inline void mlogs_(
	const char *name_a,
	const char *name_b,
	void *a,
	void *b,
	size_t nb
)
{
	uint8_t *x = a;
	uint8_t *y = b;
	printf("arrays of '%ld' bytes : '%s(%p)' - '%s(%p)'.\n", nb, name_a, a, name_b, b);
	for(size_t i = 0; i < nb; i++) {
		uint8_t c0 = x[i];
		uint8_t c1 = y[i];
		printf("- %02ld (%02hhx : %c) - (%02hhx : %c)\n", i, c0, isalpha(c0) ? c0 : ' ', c1, isalpha(c1) ? c1 : ' ');
	}
	printf("\n");
}

#ifdef DEBUG
#define mlog(a, nb, ...) printf(__VA_ARGS__); mlog_(#a, a, nb);
#define mlogs(a, b, nb, ...) printf(__VA_ARGS__); mlogs_(#a, #b, a, b, nb);
#define mdbg(a, b, nb, ...) printf(__VA_ARGS__); mlogs_(#a, #b, a, b, nb); mcmp(a, b, nb);
#else 
#define mlog(a, nb, ...) 
#define mlogs(a, b, nb, ...) 
#define mdbg(a, b, nb, ...)
#endif
