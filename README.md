# JFiTT
Lista 1 - rozpoznawanie wzorca FA i KMP

Lista 2 - Zadanie 1
Napisz we FLEX-ie program który czyta dowolny plik tekstowy, usuwa w nim wszystkie
białe znaki na końcu i na początku wiersza, zmienia wszystkie wystąpienia ciągów tabulato-
rów i spacji na dokładnie jedną spację, likwiduje puste linie, oraz na końcu dopisuje liczbę
linii i słów (ciągi znaków oddzielone białymi znakami).
Zadanie 2
Napisz w FLEX-ie program który usuwa wszystkie komentarze w plikach źródłowych XML.
Zadanie 3
Napisz w FLEX-ie program który usuwa wszystkie komentarze w programach napisanych
w języku C++, a po włączeniu odpowiedniej opcji pozostawia komentarze dokumentacyjne
(wg. Doxygen-a co najmniej następujące /**, /*!, /// i //!) i usuwa pozostałe.
Zadanie 4
Używając FLEX-a zaimplementuj prosty kalkulator postfiksowy (odwrotna notacja polska)
dla liczb całkowitych wykonujący operacje dodawania (+), odejmowania (-), mnożenia (*),
dzielenia całkowitoliczbowego (/), potęgowania (^) i modulo (%). Wyrażenie do policzenia
powinno być napisane w jednej linii. Program powinien wyświetlać dla każdej linii wynik
albo komunikat o błędzie (jak najbardziej szczegółowy). P

Lista 3 - Zadanie 1
Używając LEX-a i BISON-a zaimplementuj translator wyrażeń arytmetycznych w ciele
GF (1234577) z postaci infiksowej do postaci postfiksowej (odwrotnej notacji polskiej), z ko-
rekcją postaci liczby (w Gp nie ma liczb ujemnych i większych lub równych p), i podającej
wynik obliczenia wyrażenia. Wyrażenia do policzenia umieszczone są w osobnych liniach.
Program ma przetwarzać wszystkie linie wejścia, a linie zaczynające się od # traktować jak
linie komentarza i omijać. W przypadku długich linii ma być możliwość ich podzielenie za
pomocą znaku \ (tak jak w języku c).
Zadbaj o właściwe priorytety operatorów, właściwą łączność operatorów i odpowiednią
obsługę błędów. Pamiętaj o unarnym operatorze - dla danych wejściowych (często dla
wygody w GF (p) piszemy np. −1 zamiast p − 1). Potęgowanie powinno być dozwolone tylko
jako operacja uogólniająca mnożenie - nie wolno składać potęg (można liczyć (ab)c, ale nie
można abc. W c++ oraz python.
