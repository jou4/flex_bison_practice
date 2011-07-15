#ifndef _lexer_h_
#define _lexer_h_

#include "string_buffer.h"

typedef struct {
    StringBuffer *buf;
    void *scanner;
} Lexer;

void lexer_init(Lexer *lexer);
void _lexer_destroy(Lexer *lexer);

#define lexer_destroy(lexer) _lexer_destroy(lexer); lexer = NULL

#endif
