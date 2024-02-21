%{
#include <stdio.h>
%}

coment_start \<!--
coment_end --\>
string \".*\"

%x NO_COMMENT
%x COMMENT
%x LT_CHECK
%x string

%%

"<!--".*"--".*"-->" {ECHO;}

\" ECHO; BEGIN(string);  // Rozpoczęcie łańcucha tekstowego
<string>{
    {coment_start}         BEGIN(COMMENT);
    \"          ECHO; BEGIN(0);  // Zakończenie łańcucha tekstowego
}

\< {
    ECHO;
    BEGIN(NO_COMMENT);
}

{coment_start} BEGIN(COMMENT);

<NO_COMMENT>{
    {string} ECHO;
    > {
        ECHO;
        BEGIN(0);
    }
    "<" {
        BEGIN(LT_CHECK);
    }
    .|\n     ECHO;
}


<LT_CHECK>{
    {coment_start} BEGIN(COMMENT);
    > {
        ECHO;
        BEGIN(0);
    }
    . {
        BEGIN(NO_COMMENT);
        ECHO;
    }
}

<COMMENT>{
    .|\n       ;
    {coment_end}  BEGIN(0);
}

%%
int yywrap() {
    return 1; 
}
int main(void) {
    yyout = fopen("output.txt", "w");
    yylex();
    return 0;
}