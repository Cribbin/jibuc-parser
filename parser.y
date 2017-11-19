%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include<stdio.h>

extern int yylex();
extern int yyparse();
void yyerror(const char *s);
extern FILE *yyin;

%}
%start start
%token BEGINING
%token BODY
%token END
%token NUMSIZE
%token IDENTIFIER
%token MOVE
%token TO
%token ADD
%token INPUT
%token PRINT
%token TEXT
%token INTEGER
%token SEMICOLON
%token TERMINATOR
%token INVALID

%%
start: BEGINING TERMINATOR { printf("Start\n"); }
%%

int main() {
    do {
        yyparse();
    } while(!feof(yyin));
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s (%d)\n", s, yychar);
}
