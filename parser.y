%{

#define YYLEX_PARAM lexer->scanner, lexer->buf

%}

%define api.pure
%error-verbose

%parse-param { ParserState *ps }
%parse-param { Lexer *lexer }
%parse-param { char *stream_name }

%code requires {
#include "syntax.h"
#include "lexer.h"
}

%union {
int num;
char *str;
StringBuffer* buf;
SyntaxType* t;
}

%token <num> NUM
%token <str> IDENT
%token <buf> STRING_LITERAL

%left '+' '-'
%left '*' '/'
%left NEG
%right '^'

%type <t> exp simple_exp
%start exps

%%

exps
:
| exps exp              { show($2); }
;

simple_exp
: '(' exp ')'           { $$ = $2; }
| NUM                   { $$ = syntax_int($1); }
| IDENT                 { $$ = syntax_ident($1); }
| STRING_LITERAL        { $$ = syntax_string_literal(sb_to_string($1), $1->len); }
;

exp
: simple_exp            { $$ = $1; }
| exp '+' exp           { $$ = syntax_add($1, $3); }
| exp '-' exp           { $$ = syntax_sub($1, $3); }
| exp '*' exp           { $$ = syntax_mul($1, $3); }
| exp '/' exp           { $$ = syntax_div($1, $3); }
;

%%

int yyerror(ParserState *ps, Lexer *lexer, char *stream_name, char *msg)
{
    printf("%s(%d): %s\n", stream_name, yyget_lineno(lexer->scanner), msg);
    return 0;
}

void init_state(ParserState *ps){
    ps->count = 0;
}

int main()
{
    ParserState ps;
    Lexer lexer;

    lexer_init(&lexer);
    init_state(&ps);

    yyparse(&ps, &lexer, "input");

    return 0;
}
