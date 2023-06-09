#ifndef TEST_H
#define TEST_H
#include "moldudp64.h"
#include <stdlib.h>

#ifndef RAND_SEED
#define RAND_SEED 1
#endif // RAND_SEED

#define MSG_CNT 3
#define MSG_LEN 13
int main(){
	moldudp64_s * mold_s;
	uint8_t mold_msg[MSG_CNT][MSG_LEN];
	// create a random 
	srand(RAND_SEED);
	// fill msg with random number
	for( int c = 0; c < MSG_CNT; c++){
		for( int l = 0; l < MSG_LEN; l++){
			mold_msg[c][l] = (uint8_t) rand();
		}
	}
	mold_s = moldudp64_alloc();
	for ( int c = 0; c < MSG_CNT; c++){
		moldudp64_add_msg(mold_s, mold_msg[c], MSG_LEN);	
	} 
	moldudp64_print(mold_s);
	moldudp64_free(mold_s);
	return 0;
}
#endif // TEST_H
