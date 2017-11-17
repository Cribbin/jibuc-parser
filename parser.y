%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include<stdio.h>
int yylex();
void yyerror(const char *s);
%}
%token BEGINING BODY END NUMSIZE IDENTIFIER MOVE TO ADD INPUT PRINT TEXT INTEGER SEMICOLON TERMINATOR

%%
sentence: NUMSIZE IDENTIFIER TERMINATOR
        { printf("Is a valid sentence!"); }
%%

extern FILE *yyin;
int main() {
    do yyparse();
    while(!feof(yyin));
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s (%d)\n", s, yychar);
}
