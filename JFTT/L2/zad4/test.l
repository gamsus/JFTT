%{
#include <iostream>
#include <stack>
#include <cmath>
#include <string>

std::string error_;
std::stack<int> nums;
int x;
int y;
%}

operators [\+\-\*\^]
risky_operators [/%]

%x ERROR

%%

\-?[0-9]+   {
    nums.push(atoi(yytext));
    ECHO;
}

{operators} {
    ECHO;
    if (nums.size() >= 2) {
        y = nums.top();
        nums.pop();
        x = nums.top();
        nums.pop();
        REJECT;
    } else {
        error_ = "Błąd: za mała liczba argumentów";
        BEGIN(ERROR);
    }
}

{risky_operators} {
    ECHO;
    if (nums.size() >= 2) {
        y = nums.top();
        nums.pop();
        x = nums.top();
        nums.pop();
        if (y == 0 && (yytext[0] == '/' || yytext[0] == '%')) {
            error_ = "Błąd: dzielenie/modulo przez 0";
            BEGIN(ERROR);
        }
        REJECT;
    } else {
        std::cout << "\nBłąd: za mała liczba argumentów\n";
        error_ = "Błąd: za mała liczba argumentów";
        BEGIN(ERROR);
    }
}

"+" nums.push(x + y);
"-" nums.push(x - y);
"*" nums.push(x * y);
"^" nums.push(static_cast<int>(pow(x, y)));
"/" {
    if (y != 0) {
        nums.push(x / y);
    } else {
        error_ = "Błąd: dzielenie przez 0";
        BEGIN(ERROR);
    }
}
"%" {
    if (y != 0) {
        nums.push(x % y);
    } else {
        error_ = "Błąd: modulo przez 0";
        BEGIN(ERROR);
    }
}

\n {
    if (nums.size() == 1) {
        std::cout << "\n= " << nums.top() << "\n";
        nums.pop();
    } else if (nums.size() == 0) {
    } else {
        std::cout << "\nBłąd: za mała liczba operatorów\n";
        nums = std::stack<int>();
    }
}

"," {
    ECHO;
    error_ = "Zly symbol: ,";
    BEGIN(ERROR);
}

"." {
    ECHO;
    error_ = "Błąd: zly symbol: .";
    BEGIN(ERROR);
}

[0-9]+|{operators} {
    std::cout << "\nBłąd: za mała liczba sfdfds\n";
    error_ = "Błąd: zły symbol " + (std::string)yytext;
    ECHO;
}

<ERROR>{
    \n {
        std::cout << "\n" << error_ << "\n";
        nums = std::stack<int>();
        BEGIN(INITIAL);
    }
}

%%

int yywrap() {
    return 1;
}
int main() {
    return yylex();
}
