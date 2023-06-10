#include "tv.h"
#include <stdlib.h>
#include "file.h"
tv_t * tv_alloc(const char *path){
	tv_t *tv;
	tv = (tv_t *) malloc( sizeof(tv_t));
	tv->mold_s   = moldudp64_alloc();
	tv->flat_l   = 0; 
	tv->flat_idx = 0;
	tv->fptr = fopen( path, "rb");

	return tv; 
}

void tv_create_packet(tv_t * t, size_t itch_n){
	size_t r = 0; // read size
	size_t n; // number of messages read
	uint8_t buff[ITCH_MSG_MAX_LEN];		
	// read itch messages from file
	for( n = 0; n < itch_n ; n++){
		r = get_next_bin_msg(t->fptr, buff, ITCH_MSG_MAX_LEN);
		if ( r == 0 )break;
		// add it's contents to mold struct
		moldudp64_add_msg(t->mold_s, buff, r); 
	}
	r =	moldudp64_flatten(t->mold_s, t->flat);
	t->flat_l = r;
	t->flat_idx = 0;
	moldudp64_clear( t-> mold_s );
}
