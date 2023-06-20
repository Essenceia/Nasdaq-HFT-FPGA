#ifndef TB_CONFIG_H
#define TB_CONFIG_H


#ifndef RAND_SEED
#define RAND_SEED 10
#endif


// define a macro for the number of max messages to not have to dynamically
// allocate memory, more expensive in memory, less in computing ( perf ) 
#define MOLDUDP64_MSG_CNT_MAX 100


#endif//TB_CONFIG_H
