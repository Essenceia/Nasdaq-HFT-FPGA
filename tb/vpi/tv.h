#ifndef TV_H
#define TV_H

#include "moldudp64.h"
#include "itch_s.h"

#include <stdio.h>
typedef struct{
	FILE *       fptr;
	moldudp64_s *mold_s;
	uint8_t *flat;
	size_t  flat_l;
	size_t  flat_idx;
}tv_t;

tv_t * tv_alloc(const char * path);

void tv_create_packet(tv_t * t,size_t itch_n);
#endif // TV_H
