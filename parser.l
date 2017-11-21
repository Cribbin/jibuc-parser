%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include "y.tab.h"
int getSize(char *x);
%}

%option yylineno

%%
[\t\n ]+                    /* Ignore whitespace */ ;
(?i:BEGINING)               { return BEGINING; }
(?i:BODY)                   { return BODY; }
(?i:END)                    { return END; }
[Xx]+                       { yylval.size = getSize(yytext); return NUMSIZE; }
(?i:MOVE)                   { return MOVE; }
(?i:TO)                     { return TO; }
(?i:ADD)                    { return ADD; }
(?i:INPUT)                  { return INPUT; }
(?i:PRINT)                  { return PRINT; }
;                           { return SEMICOLON; }
[0-9]+                      { yylval.size = atoi(yytext); return INTEGER; }
[A-Za-z][A-Za-z0-9\-]*      { yylval.id = yytext; return IDENTIFIER; }
\"(\\.|[^"\\])*\"           { return TEXT; }
\.                          { return TERMINATOR; }
.                           { return 0; }
%%

int yywrap(void) {
    return 1;
}

int getSize(char *x) {
    int i = 0;
    while (*x++) i++;
    return i;
}
