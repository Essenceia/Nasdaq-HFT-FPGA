#ifndef TYPE_H
#define TYPE_H
#include <stdint.h>
#include <stdbool.h>

// typedefs

typedef uint8_t  u8_t;
typedef uint16_t u16_t;
typedef uint32_t u32_t;
typedef uint64_t u64_t;
typedef uint64_t u48_t;

typedef uint32_t price_4_t;
typedef uint64_t price_8_t;

typedef char char_t;
typedef char char_2_t[2];
typedef char char_4_t[4]; 
typedef char char_8_t[8]; 
typedef char char_10_t[10] ;
typedef char char_20_t[20] ;

#include "gen/itch_msg_enum.h"
#endif // TYPE_H
