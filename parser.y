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
%token BEGINING BODY END NUMSIZE IDENTIFIER MOVE TO ADD INPUT PRINT TEXT INTEGER SEMICOLON TERMINATOR INVALID

%%
start:          BEGINING TERMINATOR declarations {}
declarations:   declaration declarations {}
declarations:   body {}
declaration:    NUMSIZE IDENTIFIER TERMINATOR {}
body:           BODY TERMINATOR code {}
code:           line code {}
code:           end {}
line:           print | input | move | add {}
print:          PRINT printStmt {}
printStmt:      TEXT SEMICOLON printStmt {}
printStmt:      IDENTIFIER SEMICOLON printStmt {}
printStmt:      TEXT TERMINATOR {}
printStmt:      IDENTIFIER TERMINATOR {}
input:          INPUT IDENTIFIER TERMINATOR {}
move:           MOVE INTEGER TO IDENTIFIER TERMINATOR {}
add:            ADD IDENTIFIER TO IDENTIFIER TERMINATOR {}
end:            END TERMINATOR {}
%%

int main() {
    do {
        yyparse();
    } while(!feof(yyin));
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s (%d)\n", s, yychar);
}
