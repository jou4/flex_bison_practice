#ifndef _expr_h
#define _expr_h

typedef enum {
    E_INT,
    E_IDENT,
    E_STRING_LITERAL,
    E_ADD,
    E_SUB,
    E_MUL,
    E_DIV
} ExprType;

typedef struct Expr Expr;
struct Expr {
    ExprType type;
    int int_val;
    char *str_val;
    Expr *t1;
    Expr *t2;
};

Expr *expr_int(int n);
Expr *expr_ident(char *s);
Expr *expr_string_literal(char *s, int len);
Expr *expr_add(Expr *t1, Expr *t2);
Expr *expr_sub(Expr *t1, Expr *t2);
Expr *expr_mul(Expr *t1, Expr *t2);
Expr *expr_div(Expr *t1, Expr *t2);

void show(Expr *t);

#endif

