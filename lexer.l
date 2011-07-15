%{
#include <stdio.h>
#include "y.tab.h"
#include "lexer.h"

#define YY_DECL int yylex \
               (YYSTYPE * yylval_param, yyscan_t yyscanner, StringBuffer *buf)

void lexer_init(Lexer *lexer)
{
    lexer->buf = sb_new();
    yylex_init(&lexer->scanner);
}

void _lexer_destroy(Lexer *lexer)
{
    sb_destroy(lexer->buf);
    yylex_destroy(lexer->scanner);
    free(lexer);
}
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

<INITIAL>{digit}+ {
    yylval->num = atoi(yytext);
    return(NUM);
}
<INITIAL>[A-Za-z_][A-Za-z_0-9]* {
    sb_init(buf);
    sb_append_n(buf, yytext, yyleng);
    yylval->str = sb_to_string(buf);

    return(IDENT);
}

 /* String literal */
<INITIAL>"\"" {
    BEGIN(STRLIT);
    sb_init(buf);
}
<STRLIT>"\"" {
    BEGIN(INITIAL);
    yylval->buf = buf;
    return(STRING_LITERAL);
}
<STRLIT>"\\\\" { sb_append_n(buf, "\\", 1); }
<STRLIT>"\\a"  { sb_append_n(buf, "\a", 1); }
<STRLIT>"\\b"  { sb_append_n(buf, "\b", 1); }
<STRLIT>"\\f"  { sb_append_n(buf, "\f", 1); }
<STRLIT>"\\n"  { sb_append_n(buf, "\n", 1); }
<STRLIT>"\\r"  { sb_append_n(buf, "\r", 1); }
<STRLIT>"\\t"  { sb_append_n(buf, "\t", 1); }
<STRLIT>"\\v"  { sb_append_n(buf, "\v", 1); }
<STRLIT>{br}   { YY_FATAL_ERROR("unexpected newline in string literal."); BEGIN(INITIAL); }
<STRLIT>.      { sb_append_n(buf, yytext, yyleng); }

<INITIAL>"+" { return('+'); }
<INITIAL>"-" { return('-'); }
<INITIAL>"*" { return('*'); }
<INITIAL>"/" { return('/'); }


 /* Comment */
<INITIAL>\/\/[^\n]+ { }
<INITIAL>"/*"       { BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT><<EOF>>    { YY_FATAL_ERROR("unexpected end of input."); }
<COMMENT>{br}       { }
<COMMENT>.          { }


<INITIAL>{br} { }
<INITIAL>.    { }

%%
