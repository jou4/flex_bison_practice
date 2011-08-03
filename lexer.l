%{
#include <stdio.h>
#include "y.tab.h"
#include "lexer.h"

#define YY_DECL int yylex \
               (YYSTYPE * yylval_param, yyscan_t yyscanner, Lexer *lexer)

#define YY_USER_ACTION lexer_put_input_buffer(lexer, yytext, yyleng);

%}

%option reentrant
%option bison-bridge
%option noyywrap
%option yylineno

br    \n
space [ \t]
digit [0-9]
lower [a-z]
upper [A-Z]


%start STRLIT
%start COMMENT

%%

<INITIAL>"+" { return('+'); }
<INITIAL>"-" { return('-'); }
<INITIAL>"*" { return('*'); }
<INITIAL>"/" { return('/'); }
<INITIAL>"=" { return('='); }

<INITIAL>"if"   { return(IF); }
<INITIAL>"then" { return(THEN); }
<INITIAL>"else" { return(ELSE); }

<INITIAL>{digit}+ {
    yylval->num = atoi(yytext);
    return(NUM);
}
<INITIAL>[A-Za-z_][A-Za-z_0-9]* {
    sb_clear(lexer->buf);
    sb_append_n(lexer->buf, yytext, yyleng);
    yylval->str = sb_to_string(lexer->buf);

    return(IDENT);
}

 /* String literal */
<INITIAL>"\"" {
    BEGIN(STRLIT);
    sb_clear(lexer->buf);
}
<STRLIT>"\"" {
    BEGIN(INITIAL);
    yylval->buf = lexer->buf;
    return(STRING_LITERAL);
}
<STRLIT>"\\\\" { sb_append_n(lexer->buf, "\\", 1); }
<STRLIT>"\\a"  { sb_append_n(lexer->buf, "\a", 1); }
<STRLIT>"\\b"  { sb_append_n(lexer->buf, "\b", 1); }
<STRLIT>"\\f"  { sb_append_n(lexer->buf, "\f", 1); }
<STRLIT>"\\n"  { sb_append_n(lexer->buf, "\n", 1); }
<STRLIT>"\\r"  { sb_append_n(lexer->buf, "\r", 1); }
<STRLIT>"\\t"  { sb_append_n(lexer->buf, "\t", 1); }
<STRLIT>"\\v"  { sb_append_n(lexer->buf, "\v", 1); }
<STRLIT>{br}   { YY_FATAL_ERROR("unexpected newline in string literal."); BEGIN(INITIAL); }
<STRLIT>.      { sb_append_n(lexer->buf, yytext, yyleng); }

 /* Comment */
<INITIAL>\/\/[^\n]+ { }
<INITIAL>"/*"       { BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT><<EOF>>    { YY_FATAL_ERROR("unexpected end of input."); }
<COMMENT>{br}       { }
<COMMENT>.          { }


<INITIAL>{space} { }
<INITIAL>{br} { return(BR); }

<<EOF>> { return(EOF); }

%%

void lexer_init(Lexer *lexer)
{
    lexer->buf = sb_new();
    lexer->input_buf = sb_new();
    yylex_init(&lexer->scanner);
}

void _lexer_destroy(Lexer *lexer)
{
    sb_destroy(lexer->buf);
    sb_destroy(lexer->input_buf);
    yylex_destroy(lexer->scanner);
    free(lexer);
}

void lexer_clear_input_buffer(Lexer *lexer)
{
    sb_clear(lexer->input_buf);
}

void lexer_put_input_buffer(Lexer *lexer, char *text, int len)
{
    sb_append_n(lexer->input_buf, text, len);
}

void lexer_unput_input_buffer(Lexer *lexer)
{
    void *yyscanner = lexer->scanner;
    struct yyguts_t * yyg = (struct yyguts_t*)lexer->scanner;

    char *str = sb_to_string(lexer->input_buf);
    int len = lexer->input_buf->len;

    for(len--; len >= 0; len--){
        if(str[len] == '\n'){
            unput(' ');
        }else{
            unput(str[len]);
        }
    }
    free(str);

    lexer_clear_input_buffer(lexer);
}
