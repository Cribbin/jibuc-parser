%{
/*
* Written by Patrick Joseph Cribbin - 14137208
*/
#include "y.tab.h"
%}

%%
[\t\n ]+                    /* Ignore whitespace */ ;
(?i:BEGINING)               { return BEGINING; }
(?i:BODY)                   { return BODY; }
(?i:END)                    { return END; }
[Xx]+                       { return NUMSIZE; }
(?i:MOVE)                   { return MOVE; }
(?i:TO)                     { return TO; }
(?i:ADD)                    { return ADD; }
(?i:INPUT)                  { return INPUT; }
(?i:PRINT)                  { return PRINT; }
;                           { return SEMICOLON; }
[0-9]+                      { return INTEGER; }
[A-Za-z][A-Za-z0-9\-]*      { return IDENTIFIER; }
\"(\\.|[^"\\])*\"           { return TEXT; }
\.                          { return TERMINATOR; }
.                           { return 0; }
%%

