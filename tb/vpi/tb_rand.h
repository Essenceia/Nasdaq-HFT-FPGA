#ifndef TB_RAND_H
#define TB_RAND_H

#include <stdlib.h>
#include "tb_config.h"
 
static inline void tb_rand_init(unsigned seed){
	srand(seed);
}

static inline uint16_t tb_rand_get_msg_cnt(){
	uint16_t rand_cnt = (uint16_t) ( rand() % MOLDUDP64_MSG_CNT_MAX );
	return rand_cnt ? rand_cnt : 1;
}
#endif//TB_RAND_H
