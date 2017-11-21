%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#define NUM_VARIABLES 50

extern int yylex();
extern int yyparse();
void yyerror(const char *s);
extern FILE *yyin;
extern int lineNo;

char identifiers[NUM_VARIABLES][32];
int sizes[NUM_VARIABLES];

int varCounter = 0;
int getVarSize(char *var);
void addVar(int size, char *name);
void moveIntToVar(int num, char *var);
void moveIdToVar(char *var1, char *var2);
void removeEnding(char *var);
int isVar(char *var);
void getFirstVar(char *var);

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
input:          INPUT inputStmt {}
inputStmt:      IDENTIFIER TERMINATOR { isVar($1); }
                | IDENTIFIER SEMICOLON inputStmt { isVar($1); }
move:           MOVE INTEGER TO IDENTIFIER TERMINATOR { moveIntToVar($2, $4); }
                | MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { moveIdToVar($2, $4); }
add:            ADD IDENTIFIER TO IDENTIFIER TERMINATOR {}
end:            END TERMINATOR { exit(EXIT_SUCCESS); }
%%

int main() {
    do {
        yyparse();
    } while(!feof(yyin));
}

void yyerror(const char *s) {
    fprintf(stderr, "Error (L%d): %s\n", lineNo, s);
}

void moveIntToVar(int num, char *var) {
    removeEnding(var);
    int size = getVarSize(var);

    if (size > -1) {
        int inputDigits = floor(log10(abs(num))) + 1;

        if (inputDigits > size) {
            printf("Warning (L%d): Integer is too large. Expected %d digits or less, is %d.\n", lineNo, size, inputDigits);
        }
    } else {
        printf("Warning (L%d): Integer cannot be assigned. Identifier %s not initialised.\n", lineNo, var);
    }
}

int isVar(char *var) {
    removeEnding(var);
    if (strstr(var, ";") != NULL) {
        getFirstVar(var);
    }
    for (int i = 0; i < varCounter; i++) {
        if (strcmp(var, identifiers[i]) == 0) {
            return 1;
        }
    }
    printf("Warning (L%d): Identifier %s not initialised.\n", lineNo, var);
    return 0;
}

void moveIdToVar(char *var1, char *var2) {
    int size1 = getVarSize(var1);
    int size2 = getVarSize(var2);

    printf("Size 1: %d | Size 2: %d\n", size1, size2);

    if (size1 > size2) {
        printf("Warning (L%d): Moving %s (%d digits) to %s (%d digits).\n", lineNo, var1, size1, var2, size2);
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
    removeEnding(name);
    strcpy(identifiers[varCounter], name);
    sizes[varCounter] = size;
    varCounter++;
}

void removeEnding(char *var) {
    if (var[strlen(var)-1] == '.') {
        var[strlen(var)-1] = 0;
    }
}

void getFirstVar(char *var) {
    for (int i = 0; i < strlen(var); i++) {
        if (var[i] == ';') {
            var[i] = '\0';
            break;
        }
    }
}
