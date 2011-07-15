%{

#include <stdio.h>
#include "vector.h"

#define YYDEBUG 1
#define YYLEX_PARAM lexer->scanner, lexer->buf

typedef struct {
   Vector *exps;
} ParserState;

%}

%code requires {
#include "lexer.h"
#include "expr.h"
}

%define api.pure
%error-verbose

%parse-param { ParserState *ps }
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
| exp { show($1); YYACCEPT; }
;

exps
:
| exps exp              { /*vector_add(ps->exps, $2);*/show($2); }
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
| IF simple_exp THEN simple_exp ELSE simple_exp { $$ = $2; }
;

%%

int yyerror(ParserState *ps, Lexer *lexer, char *stream_name, char *msg)
{
    fprintf(stderr, "%s(%d): %s\n", stream_name, yyget_lineno(lexer->scanner), msg);
    return 0;
}

void init_state(ParserState *ps){
    ps->exps = vector_new();
}

void destroy_state(ParserState *ps){
}

int main()
{
    ParserState ps;
    Lexer lexer;

    lexer_init(&lexer);
    init_state(&ps);

//yydebug = 1;
    if(yyparse(&ps, &lexer, "input") == 0){
        int i;
        for(i = 0; i < ps.exps->length; i++){
            show(vector_get(ps.exps, i));
        }
    }

    return 0;
}
