bison -d -y parser.y
flex lexer.l
gcc -o parser y.tab.c lex.yy.c syntax.c string_buffer.c
