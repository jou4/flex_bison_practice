#include "syntax.h"

SyntaxType *create_syntax_type(SyntaxTypeType type){
    SyntaxType *t = (SyntaxType*)malloc(sizeof(SyntaxType));
    t->type = type;
    return t;
}

SyntaxType *create_binary_syntax_type(SyntaxTypeType type, SyntaxType *t1, SyntaxType *t2){
    SyntaxType *t = create_syntax_type(type);
    t->t1 = t1;
    t->t2 = t2;
    return t;
}

SyntaxType *syntax_int(int n){
    SyntaxType *t = create_syntax_type(INT);
    t->int_val = n;
    return t;
}

SyntaxType *syntax_ident(char *s){
    SyntaxType *t = create_syntax_type(S_IDENT);
    t->str_val = s;
    return t;
}

SyntaxType *syntax_string_literal(char *s, int len){
    SyntaxType *t = create_syntax_type(S_STRING_LITERAL);
    t->str_val = s;
    return t;
}

SyntaxType *syntax_add(SyntaxType *t1, SyntaxType *t2){
    return create_binary_syntax_type(ADD, t1, t2);
}

SyntaxType *syntax_sub(SyntaxType *t1, SyntaxType *t2){
    return create_binary_syntax_type(SUB, t1, t2);
}

SyntaxType *syntax_mul(SyntaxType *t1, SyntaxType *t2){
    return create_binary_syntax_type(MUL, t1, t2);
}

SyntaxType *syntax_div(SyntaxType *t1, SyntaxType *t2){
    return create_binary_syntax_type(DIV, t1, t2);
}

void show(SyntaxType *t){
    switch(t->type){
        case INT:
            printf("int:: %d\n", t->int_val);
            break;
        case S_IDENT:
            printf("ident:: %s\n", t->str_val);
            break;
        case S_STRING_LITERAL:
            printf("string literal:: %s\n", t->str_val);
            break;
        case ADD:
            printf("add\n");
            show(t->t1);
            show(t->t2);
            break;
        case SUB:
            printf("sub\n");
            show(t->t1);
            show(t->t2);
            break;
        case MUL:
            printf("mul\n");
            show(t->t1);
            show(t->t2);
            break;
        case DIV:
            printf("div\n");
            show(t->t1);
            show(t->t2);
            break;
        default:
            printf("nothing\n");
            break;
    }
}

