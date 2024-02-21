%{
#define YYSTYPE int  
#include <iostream>
#include <string>
#include <cmath>

using namespace std;

const int P = 1234577;
string rpn = "";
string error_msg = "";

int yylex();
int yyerror(string);
int ZP(int a,int p);
int extendedGCD(int a, int b, int& x, int& y); 
int modPow(int base, int exp, int p);
int modInv(int a, int p);
int mult(int a, int b, int p);
int sub(int a, int b, int p);
int add(int a, int b, int p);
%}

%token NUM END ERROR 
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'

%type expr

%%
program:
    %empty
    | program line
;

line: expr END {cout<<rpn<<endl;rpn = "";printf("Wynik %d\n",$$);}
      | error END {if(error_msg == ""){ error_msg = "zla skladnia";} cout<<error_msg<<endl; rpn =""; error_msg = "";}
      ;

expr: n1   {rpn += to_string($1) + " "; $$ = $1; }  // Single number
          | expr '+' expr   { $$ = add($1,$3,P); rpn += "+ "; }  // Addition
          | expr '-' expr  { $$ = sub($1,$3,P); rpn += "- "; }  // Subtraction
          | expr '*' expr  { $$ = mult($1,$3,P) ; rpn += "* "; }  // Multiplication
          | expr '/' expr { 
            if($3 != 0){
                $$ = mult($1,modInv($3,P),P); rpn += "/ "; 
            }
            else{
                rpn = "";
                error_msg = "element "+to_string($3)+" nieodwracalny w ciele("+to_string(P)+")";
                YYERROR;     
            }}
          | expr '^' exp  {$$ = modPow(ZP($1,P), $3,P); rpn += "^ ";}  // Exponentiation
          | '(' expr ')' { $$ = $2; }  // Parentheses
          | '-' expr  %prec NEG { $$ = ZP(-$2,P); rpn += "~ "; }  // Unary minus
          ;
          
exp: n2 {rpn += to_string($1) + " ";$$ = $1;}  // Single number
    
    | exp '+' exp  { $$ = add($1,$3,P-1);rpn += "+. "; }  // . for modulo P-1
    | exp '-' exp  { $$ = sub($1,$3,P-1);rpn += "-. ";  }  // . for modulo P-1
    | exp '*' exp  { $$ = mult($1,$3,P-1);rpn += "*. "; }  // . for modulo P-1
    | exp '/' exp { 
        int inv = modInv($3,P-1); 
        if(inv != -1){
            $$ = mult($1,inv,P-1); rpn += "/. ";  
        }
        else{
            rpn = "";
            error_msg = "element "+to_string($3)+" nie jest odwracalny w ciele ZP("+to_string(P-1)+")";
            YYERROR;     
        }
    }
    | '(' exp ')' { $$ = $2; }  // Parentheses for modulo P-1
    | '-'  exp  %prec NEG { $$ = ZP(-$2,P-1);rpn += "~ ";}  // Unary minus for modulo P-1
    ;

n1:
    NUM {$$ = ZP($1,P);}  // Convert number to ZP(P)

n2:
    NUM {$$ = ZP($1,P-1);}  // Convert number to ZP(P-1)
%%

int yyerror(string s) {
    return 0;
}

int ZP(int a,int p) {
    while(a < 0) {
        a = a + p;
    }
    return a % p;
}

int add(int a, int b, int p) {
    return ZP(ZP(a, p) + ZP(b, p), p);
}

int sub(int a, int b, int p) {
    return ZP(ZP(a, p) - ZP(b, p), p);
}

int mult(int a, int b, int p) {
    a = ZP(a, p);
    b = ZP(b, p);
    int result = 0;
    while (b > 0) {
        if (b % 2 == 1) {
            result = ZP(add(result, a, p), p);
        }
        a = ZP(add(a, a, p), p);
        b /= 2;
    }
    return result;
}

int modPow(int a, int pow, int p) {
    
    int w = 1;
    if(pow >= 0){

        while(pow > 0){
            if(pow % 2 == 1){
                w = mult(w,a,p);
            }
        a = mult(a,a,p);
        pow = pow/2;
        }
    }
    return w;
}

int extendedGCD(int a, int b, int& x, int& y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }
    int x1, y1;
    int gcd = extendedGCD(b, a % b, x1, y1);
    x = y1;
    y = x1 - (a / b) * y1;
    return gcd;
}

int modInv(int a, int p) {
    int x, y;
    int gcd = extendedGCD(a, p, x, y);
    if (gcd != 1) {
        return -1;
    }
    return ZP(x,p) ;
}

int main(void) {
    yyparse();
    return 0;
}