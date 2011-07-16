echo "-----------------------------"
echo "depends on ..."
echo "  bison >= 2.5"
echo "  flex >= 2.5.35"
echo "-----------------------------"
echo ""

bison -d -y parser.y
flex lexer.l
gcc -o parser y.tab.c lex.yy.c expr.c string_buffer.c vector.c
