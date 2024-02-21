%{
#include <stdio.h>
int flag;
%}

%x include
%x string
%x multi_line
%x doc

ALL .

%%

((\/(\\\n)*\/(\\\n)*\/)|(\/(\\\n)*\/(\\\n)*!)).*(\\\n.*)*	{if(flag) ECHO;};

\/(\\\n)*\/.*(\\\n.*)* ;

(\/\*\*|\/\*!) {if(flag) ECHO; BEGIN(doc);};  // Komentarze dokumentacyjne
<doc>{
    {ALL}   {if(flag) ECHO;}  // Wypisanie treści komentarza dokumentacyjnego
    "*/"    {if(flag) ECHO; BEGIN(0);}  // Zakończenie komentarza dokumentacyjnego
}

\/\*            {BEGIN(multi_line);};  // Rozpoczęcie komentarza wielolinijkowego
<multi_line>{
    "*/"        BEGIN(0);  // Zakończenie komentarza wielolinijkowego
    {ALL}       ;  // Ignorowanie treści komentarza wielolinijkowego
}

\" ECHO; BEGIN(string);  // Rozpoczęcie łańcucha tekstowego
<string>{
    \\\"        ECHO;  // Wypisanie sekwencji "\\"
    \"          ECHO; BEGIN(0);  // Zakończenie łańcucha tekstowego
}
 
"#include"[ \t\n\\\n]+< ECHO; BEGIN(include);  // Rozpoczęcie dyrektywy #include
<include>{
    ">"         ECHO; BEGIN(0);  // Zakończenie dyrektywy #include
}


%%

int yywrap() {
    return 1; 
}

int main(int argc, char** argv) {
    flag = 1;
    yyout = fopen("result.cpp", "w");
    yylex();
    return 0;
}
