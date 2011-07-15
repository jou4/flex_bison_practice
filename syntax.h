#ifndef _syntax_h
#define _syntax_h

#include <stdlib.h>
#include <stdio.h>

typedef struct {
    int count;
} ParserState;

typedef enum {
    INT,
    S_IDENT,
    S_STRING_LITERAL,
    ADD,
    SUB,
    MUL,
    DIV
} SyntaxTypeType;

typedef struct SyntaxType SyntaxType;
struct SyntaxType {
    SyntaxTypeType type;
    int int_val;
    char *str_val;
    SyntaxType *t1;
    SyntaxType *t2;
};

SyntaxType *syntax_int(int n);
SyntaxType *syntax_ident(char *s);
SyntaxType *syntax_string_literal(char *s, int len);
SyntaxType *syntax_add(SyntaxType *t1, SyntaxType *t2);
SyntaxType *syntax_sub(SyntaxType *t1, SyntaxType *t2);
SyntaxType *syntax_mul(SyntaxType *t1, SyntaxType *t2);
SyntaxType *syntax_div(SyntaxType *t1, SyntaxType *t2);

void show(SyntaxType *t);

#endif
