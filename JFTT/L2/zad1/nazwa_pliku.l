%{
    #include <stdio.h>
    #include <string.h>
    int line_count = 0;
    int word_count = 0;
    int flag = 1;
%}

%option noyywrap

%%

^[ \t]*\n   { ; }  // Usuwanie pustych linii
^[ \t]+     { ; }  // Usuwanie białych znaków na początku linii
[ \t]+$     { ; }  // Usuwanie białych znaków na końcu linii
[ \t]+      { ; }  // Zamiana wielokrotnych spacji na pojedynczą spację
\n          { fprintf(yyout, "\n"); flag = 1; }
[a-zA-Z]+   { if(flag == 1) {
    flag = 0;
    ECHO; word_count++;
    line_count++;
} else {
    fprintf(yyout, " ");
    ECHO; word_count++;
}}

%%

int main(void) {

    yyout = fopen("output.txt", "w");  // Otwarcie pliku do zapisu

    yylex();

    fclose(yyout);  // Zamknięcie pliku

    printf("Liczba linii: %d\n", line_count);
    printf("Liczba słów: %d\n", word_count);

    return 0;
}