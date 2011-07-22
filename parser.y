%{

#include <stdio.h>

#define YYDEBUG 1
#define YYLEX_PARAM lexer->scanner, lexer

typedef struct {
   int mode;
} Parser;

%}

%code requires {
#include "lexer.h"
#include "expr.h"
}

%define api.pure
%error-verbose

%parse-param { Parser *ps }
%parse-param { Lexer *lexer }
%parse-param { char *stream_name }

%union {
  int num;
  char *str;
  StringBuffer* buf;
  Expr* t;
}

%token <num> NUM
%token <str> IDENT
%token <buf> STRING_LITERAL
%token BR
%token IF
%token THEN
%token ELSE

%left '+' '-'
%left '*' '/'
%left NEG
%right '^'

%type <t> exp simple_exp
%start input

%%

input
:
| input line
;

line
: BR
| exp BR { show($1); lexer_clear_input_buffer(lexer); }
| error { if(ps->mode == 1){ lexer_unput_input_buffer(lexer); } YYABORT; }
;

simple_exp
: '(' exp ')'           { $$ = $2; }
| NUM                   { $$ = expr_int($1); }
| IDENT                 { $$ = expr_ident($1); }
| STRING_LITERAL        { $$ = expr_string_literal(sb_to_string($1), $1->len); }
;

exp
: simple_exp            { $$ = $1; }
| exp '+' exp           { $$ = expr_add($1, $3); }
| exp '-' exp           { $$ = expr_sub($1, $3); }
| exp '*' exp           { $$ = expr_mul($1, $3); }
| exp '/' exp           { $$ = expr_div($1, $3); }
| '-' exp
    %prec NEG           { $2->int_val = -($2->int_val); $$ = $2; }
| IF simple_exp THEN simple_exp ELSE simple_exp { $$ = $2; }
;

%%

int yyerror(Parser *ps, Lexer *lexer, char *stream_name, char *msg)
{
    if(ps->mode == 0){
        fprintf(stderr, "%s(%d): %s\n", stream_name, yyget_lineno(lexer->scanner), msg);
    }
    return 0;
}

void init_state(Parser *ps){
    ps->mode = 0;
}

void destroy_state(Parser *ps){
}

int main(int argc, char **argv)
{
    Parser ps;
    Lexer lexer;

    init_state(&ps);
    lexer_init(&lexer);

    if(argc > 1 && strcmp(argv[1], "-i") == 0){
        ps.mode = 1;   // interactive shell mode
    }

//yydebug = 1;
    if(ps.mode == 0){
        yyparse(&ps, &lexer, "input");
    }else{
        for(;;){
            yyparse(&ps, &lexer, "input");
        }
    }

    return 0;
}
