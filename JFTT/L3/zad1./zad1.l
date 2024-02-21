%option noyywrap
%{
    #include "zad1.tab.h"
    #include <iostream>
    int yylex();
    const int p = 1234577;

%}
escapedNewLine \\\n

%%
^#(.|{escapedNewLine})*\n ;
{escapedNewLine} ;
[ \t]+  ;
[0-9]+  { yylval = atoi(yytext); return NUM; }
[+]     { return '+'; }
[-]     { return '-'; }
[*]     { return '*'; }
[/]     { return '/'; }
[\^]    { return '^'; }
[(]     { return '('; }
[)]     { return ')'; }
\n      { return END; }
.       { return ERROR;}

%%