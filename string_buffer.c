#include <stdlib.h>
#include "string_buffer.h"

int sb_resize(StringBuffer *sb, int size)
{
    char *buf = (char *)realloc(sb->buf, sizeof(char) * size);
    if(buf == NULL){
        return 0;
    }
    sb->buf = buf;
    sb->size = size;
    return 1;
}

StringBuffer *sb_new()
{
    StringBuffer *sb = (StringBuffer *)malloc(sizeof(StringBuffer));

    if( ! sb_resize(sb, BUFFER_SIZE)){
        sb_destroy(sb);
        return NULL;
    }

    sb_clear(sb);
    return sb;
}

void sb_clear(StringBuffer *sb)
{
    sb->len = 0;
    sb->buf[0] = '\0';
}

void _sb_destroy(StringBuffer *sb)
{
    free(sb->buf);
    free(sb);
}

int sb_append_n(StringBuffer *sb, const char *str, int size)
{
    int newsize, needsize;
    needsize = sb->len + size;
    if(sb->size < sb->len + size){
        newsize = sb->size * 2;
        while(newsize < needsize){
            newsize *= 2;
        }
        if( ! sb_resize(sb, newsize)){
            sb_destroy(sb);
            return 0;
        }
    }

    strncat(sb->buf, str, size);
    sb->len += size;

    return 1;
}

char *sb_to_string(StringBuffer *sb)
{
    char *str = (char *)malloc(sizeof(char) * (sb->len + 1));
    strncpy(str, sb->buf, sb->len);
    str[sb->len] = '\0';
    return str;
}
