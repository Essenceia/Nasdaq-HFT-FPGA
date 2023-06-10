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

// define a macro for the number of max messages to not have to dynamically
// allocate memory, more expensive in memory, less in computing ( perf ) 
#define MOLDUDP64_MSG_CNT_MAX 100

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
#endif // MOLDUDP64_H

