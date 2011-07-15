bison -d -y parser.y
flex lexer.l
gcc -o parser y.tab.c lex.yy.c expr.c string_buffer.c vector.c
