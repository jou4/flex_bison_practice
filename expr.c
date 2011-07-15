#include <stdio.h>
#include <stdlib.h>
#include "expr.h"


Expr *create_expr_type(ExprType type){
    Expr *t = (Expr*)malloc(sizeof(Expr));
    t->type = type;
    return t;
}

Expr *create_binary_expr_type(ExprType type, Expr *t1, Expr *t2){
    Expr *t = create_expr_type(type);
    t->t1 = t1;
    t->t2 = t2;
    return t;
}

Expr *expr_int(int n){
    Expr *t = create_expr_type(E_INT);
    t->int_val = n;
    return t;
}

Expr *expr_ident(char *s){
    Expr *t = create_expr_type(E_IDENT);
    t->str_val = s;
    return t;
}

Expr *expr_string_literal(char *s, int len){
    Expr *t = create_expr_type(E_STRING_LITERAL);
    t->str_val = s;
    return t;
}

Expr *expr_add(Expr *t1, Expr *t2){
    return create_binary_expr_type(E_ADD, t1, t2);
}

Expr *expr_sub(Expr *t1, Expr *t2){
    return create_binary_expr_type(E_SUB, t1, t2);
}

Expr *expr_mul(Expr *t1, Expr *t2){
    return create_binary_expr_type(E_MUL, t1, t2);
}

Expr *expr_div(Expr *t1, Expr *t2){
    return create_binary_expr_type(E_DIV, t1, t2);
}

void show(Expr *t){
    if(t == NULL){
        printf("NULL\n");
        return;
    }

    switch(t->type){
        case E_INT:
            printf("int:: %d\n", t->int_val);
            break;
        case E_IDENT:
            printf("ident:: %s\n", t->str_val);
            break;
        case E_STRING_LITERAL:
            printf("string literal:: %s\n", t->str_val);
            break;
        case E_ADD:
            printf("add\n");
            show(t->t1);
            show(t->t2);
            break;
        case E_SUB:
            printf("sub\n");
            show(t->t1);
            show(t->t2);
            break;
        case E_MUL:
            printf("mul\n");
            show(t->t1);
            show(t->t2);
            break;
        case E_DIV:
            printf("div\n");
            show(t->t1);
            show(t->t2);
            break;
        default:
            printf("nothing\n");
            break;
    }
}


