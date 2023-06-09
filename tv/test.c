#ifndef TEST_H
#define TEST_H
#include "moldudp64.h"
#include "file.h"

#include <stdlib.h>

#ifndef RAND_SEED
#define RAND_SEED 1
#endif // RAND_SEED

#define MSG_CNT 3
#define MSG_LEN_MAX 100
int main(){
	moldudp64_s * mold_s;
	FILE *fptr;
	uint8_t mold_msg[MSG_LEN_MAX];
	size_t  msg_len;
	// create a random 
	srand(RAND_SEED);
	// open binary file
	fptr = fopen("12302019.NASDAQ_ITCH50", "rb");
	mold_s = moldudp64_alloc();
	// read file content to struct
	for( int c = 0; c < MSG_CNT; c++){
		msg_len = get_next_bin_msg(	fptr, mold_msg, MSG_LEN_MAX);
		moldudp64_add_msg(mold_s, mold_msg, msg_len);	
	}
	moldudp64_print(mold_s);
	moldudp64_free(mold_s);
	return 0;
}
#endif // TEST_H
