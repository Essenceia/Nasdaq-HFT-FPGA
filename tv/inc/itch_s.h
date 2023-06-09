#ifndef ITCH_S_H
#define ITCH_S_H
#include "type.h"

typedef struct __attribute__((__packed__)){
#include "gen/itch_msg_struct_head.h"
#include "gen/itch_msg_struct_inner.h"
}tv_itch5_s;

#endif // ITCH_S_H

