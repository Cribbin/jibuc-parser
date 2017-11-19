%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#define NUM_VARIABLES 10

extern int yylex();
extern int yyparse();
void yyerror(const char *s);
extern FILE *yyin;

char identifiers[NUM_VARIABLES][32] = {"", "", "", "", "", "", "", "", "", ""};
int sizes[NUM_VARIABLES] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

int varCounter = 0;
int getVarSize(char *var);
void addVar(int size, char *name);
void moveToVar(int num, char *var);

%}
%union {char *id; int size;}
%start start
%token <size> INTEGER
%token <size> NUMSIZE
%token <id> IDENTIFIER
%token BEGINING BODY END MOVE TO ADD INPUT PRINT TEXT SEMICOLON TERMINATOR INVALID

%%
start:          BEGINING TERMINATOR declarations {}
declarations:   declaration declarations {}
                | body {}
declaration:    NUMSIZE IDENTIFIER TERMINATOR { addVar($1, $2); }
body:           BODY TERMINATOR code {}
code:           line code {}
                | end {}
line:           print | input | move | add {}
print:          PRINT printStmt {}
printStmt:      TEXT SEMICOLON printStmt {}
                | IDENTIFIER SEMICOLON printStmt {}
                | TEXT TERMINATOR {}
                | IDENTIFIER TERMINATOR {}
input:          INPUT IDENTIFIER TERMINATOR {}
move:           MOVE INTEGER TO IDENTIFIER TERMINATOR { moveToVar($2, $4); }
add:            ADD IDENTIFIER TO IDENTIFIER TERMINATOR {}
end:            END TERMINATOR { exit(EXIT_SUCCESS); }
%%

int main() {
    do {
        yyparse();
    } while(!feof(yyin));
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s (%d)\n", s, yychar);
}

void moveToVar(int num, char *var) {
    int size = getVarSize(var);

    int inputDigits = floor(log10(abs(num))) + 1;
    
    if (inputDigits > size) {
        printf("Error: Integer is too large. Expected %d or less, is %d\n", size, inputDigits);
    }
}

int getVarSize(char *var) {
    for (int i = 0; i < varCounter; i++) {
        if (strcmp(var, identifiers[i]) == 0) {
            return sizes[i];
        }
    }
    return -1;
}

void addVar(int size, char *name) {
    strcpy(identifiers[varCounter], name);
    sizes[varCounter] = size;
    printf("Name: %s | Size: %d\n", identifiers[varCounter], sizes[varCounter]);
    varCounter++;
}
