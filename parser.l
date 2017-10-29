%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include "y.tab.h"
void printToken(int, char*);
%}

%%
[\t\n ]+            /* Ignore whitespace */ ;
(?i:BEGINING)       { printToken(BEGINING, "BEGINING"); }
(?i:BODY)           { printToken(BODY, "BODY"); }
(?i:END)            { printToken(END, "END"); }
^[Xx]+              { printToken(SIZE, "SIZE"); }
(?i:MOVE)           { printToken(MOVE, "MOVE"); }
(?i:TO)             { printToken(TO, "TO"); }
(?i:ADD)            { printToken(ADD, "ADD"); }
(?i:INPUT)          { printToken(INPUT, "INPUT"); }
(?i:PRINT)          { printToken(PRINT, "PRINT"); }
;                   { printToken(SEMICOLON, "SEMICOLON"); }
[0-9]+              { printToken(INTEGER, "INTEGER"); }
[A-Za-z0-9\-]+      { printToken(IDENTIFIER, "IDENTIFIER"); }
\".*\"              { printToken(TEXT, "TEXT"); }
\.                  { printToken(TERMINATOR, "TERMINATOR"); printf("\n"); }
.                   { return(0); }
%%

int main() {
    yylex();
    return(0);
}

void printToken(int token, char *name) {
    printf("%s(%d) ", name, token);
}
