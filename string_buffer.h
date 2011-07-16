#ifndef _string_buffer_h_
#define _string_buffer_h_

#include <string.h>

#define BUFFER_SIZE 256

typedef struct {
    int len;
    char *buf;
    int size;
} StringBuffer;

StringBuffer *sb_new();
void sb_clear(StringBuffer *sb);
void _sb_destroy(StringBuffer *sb);
int sb_append_n(StringBuffer *sb, const char *str, int size);
char *sb_to_string(StringBuffer *sb);

#define sb_destroy(sb) _sb_destroy(sb); sb = NULL
#define sb_append(sb, str) sb_append_n(sb, str, strlen(str))

#endif
