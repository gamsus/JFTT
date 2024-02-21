from ply import lex
import ply.yacc as yacc

P = 1234577
rpn = []


def ZP(a: int, p: int) -> int:
    while a < 0:
        a = a + p
    return a % p


def add(a: int, b: int, p: int) -> int:
    return ZP(ZP(a, p) + ZP(b, p), p)


def sub(a: int, b: int, p: int) -> int:
    return ZP(ZP(a, p) - ZP(b, p), p)


def multiplication(a: int, b: int, p: int) -> int:
    a = ZP(a, p)
    b = ZP(b, p)
    suma = 0

    while b > 0:
        if b % 2 == 1:
            suma = ZP(add(suma, a, p), p)
        a = ZP(add(a, a, p), p)
        b //= 2

    return suma


def modPow(a, power, p):
    w = 1

    if power >= 0:
        while power > 0:
            if power % 2 == 1:
                w = multiplication(w, a, p)
            a = multiplication(a, a, p)
            power = power // 2

    return w


def inverse(a: int, p: int) -> int:
    """ Extended Euclidean Algorithm for finding modular inverse """
    m = p
    x = 1
    y = 0

    while a > 1:
        try:
            quotient = a // m
        except:
            return
        t = m

        m = a % m
        a = t
        t = y

        y = x - quotient * y
        x = t

    if x < 0:
        x += p

    return x


tokens = (
    'PLUS',
    'MINUS',
    'TIMES',
    'DIV',
    'LPAREN',
    'RPAREN',
    'NUMBER',
    'COM',
    'POW'
)

t_ignore = ' \t'

t_PLUS = r'\+'
t_MINUS = r'-'
t_TIMES = r'\*'
t_DIV = r'/'
t_LPAREN = r'\('
t_RPAREN = r'\)'
t_COM = r'\#.*'
t_POW = r'\^'


def t_NUMBER(t):
    r'[0-9]+'
    t.value = int(t.value)
    rpn.append(t.value)
    return t


def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)


def t_error(t):
    print("Invalid Token:", t.value[0])


lexer = lex.lex()

precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIV'),
    ('right', 'UMINUS', 'POW')
)


def p_STAR_EXPR(p):
    'STAR : EXPR'
    if p[1] is not None:

        for i in rpn:
            print(i, end=' ')
        print("")
        print('Wynik: ', ZP(p[1], P))

def p_STAR_COM(p):
    'STAR : COM'
    pass


def p_add(p):
    'EXPR : EXPR PLUS EXPR'
    p[0] = add(ZP(p[1], P), ZP(p[3], P), P)
    rpn.append("+")


def p_sub(p):
    'EXPR : EXPR MINUS EXPR'
    p[0] = sub(ZP(p[1], P), ZP(p[3], P), P)
    rpn.append("-")


def p_expr2uminus(p):
    'EXPR : MINUS EXPR %prec UMINUS'
    p[0] = sub(0, ZP(p[2], P), P)
    rpn.append("~")


def p_mult(p):
    'EXPR : EXPR TIMES EXPR'
    p[0] = multiplication(p[1], p[3], P)
    rpn.append("*")


def p_div(p):
    'EXPR : EXPR DIV EXPR'
    x = p[1]
    y = p[3]
    if y == 0:
        print('Error: dzielenie przez 0')
        return
    p[0] = multiplication(x, inverse(y, P), P)
    rpn.append("/")


def p_pow(p):
    'EXPR : EXPR POW EXP'
    p[0] = modPow(ZP(p[1], P), ZP(p[3], P), P)
    rpn.append("^")

#####
def p_expnumr_neg(p):
    'EXPONUMR : NUMBER'
    p[0] = ZP(p[1], P - 1)


def p_exp_neg(p):
    'EXP : MINUS EXP %prec UMINUS'
    p[0] = sub(0, ZP(p[2], P - 1), P - 1)
    rpn.append("~")


def p_exp_add(p):
    'EXP : EXP PLUS EXP'
    p[0] = add(p[1], p[3], P - 1)
    rpn.append("+")


def p_exp_sub(p):
    'EXP : EXP MINUS EXP'
    p[0] = sub(p[1], p[3], P - 1)
    rpn.append("-")


def p_exp_mult(p):
    'EXP : EXP TIMES EXP'
    p[0] = multiplication(p[1], p[3], P - 1)
    rpn.append("*")


def p_exp_div(p):
    'EXP : EXP DIV EXP'
    x = p[1]
    y = p[3]
    if y == 0:
        print('Error: dzielenie przez 0')
        return
    i = inverse(y, P - 1)
    if i is None:
        print(f'{y} nie jest odwracalne modulo 123456')
        return
    p[0] = multiplication(x, ZP(inverse(y, P - 1), P-1), P - 1)
    rpn.append("/")


def p_exp_parens(p):
    'EXP : LPAREN EXP RPAREN'
    p[0] = p[2]


def p_EXPO_NUM(p):
    'EXP : EXPONUMR'
    p[0] = p[1]


def p_expr2NUM(p):
    'EXPR : NUMBER'
    p[0] = p[1]


def p_parens(p):
    'EXPR : LPAREN EXPR RPAREN'
    p[0] = p[2]


def p_error(p):
    if p != None:
        print(f'syntax error: ‘{p.value}’')
    else:
        print(f'syntax error')


parser = yacc.yacc()

while True:
    data = input("")
    rpn = []
    try:
        result = parser.parse(data)
    except Exception as e:
        print('', end="")
