#ifndef FILE_H
#define FILE_H
#include <stdint.h>
#include <stdio.h>
int read_bin_file(FILE* fptr, uint32_t l);

size_t get_next_bin_msg(FILE *fptr, uint8_t *buff, size_t buff_len);
#endif // FILE_H
