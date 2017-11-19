#!/bin/bash
lex parser.l && yacc -d parser.y && gcc lex.yy.c y.tab.c -o example.o && ./example.o
