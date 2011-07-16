#ifndef _lexer_h_
#define _lexer_h_

#include "string_buffer.h"

typedef struct {
    StringBuffer *buf;
    StringBuffer *input_buf;
    void *scanner;
} Lexer;

void lexer_init(Lexer *lexer);
void _lexer_destroy(Lexer *lexer);
void lexer_clear_input_buffer(Lexer *lexer);
void lexer_put_input_buffer(Lexer *lexer, char *text, int len);
void lexer_unput_input_buffer(Lexer *lexer);

#define lexer_destroy(lexer) _lexer_destroy(lexer); lexer = NULL

#endif
