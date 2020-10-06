scalarMult(_, [], []). %cand prima lista devine vida, nu cont cu ce o inmultim, rez este o lista vida
scalarMult(X, [H|T], R) :- Hr is X * H, scalarMult(X, T, Tr), R = (Hr|Tr).
%sau scalarMult(X, [H|T], R) :- Hr is X * H, scalarMult(X, T, Tr), scalarMult(X,T,Tr).


%dot([2, 5, 6], [3, 4, 1], Result).
dot([], [], 0). %ne oprim cand listele sunt vide. 0 el neutru la inmultire
dot([H1|T1], [H2|T2], R) :- Hr is H1 * H2, dot(T1, T2, Tr), R is Tr + Hr.
%R se calculeaza dupa apelul recursiv deoarece are nevoie de Tr calculat

%maxim lista
%max([4, 2, 6, 8, 1], Result).
max([], 0).
%max([1], M) :- max([], M1).%cand am un sng element compar cu maximul definit la lista vida
%max([X], X). %ne oprim pe ultimul element
max([H|T], Max) :- max(T, Max1), H >= Max1, Max = H.
max([H|T], Max) :- max(T, Max1), H < Max1, Max = Max1.

%sau
%max([H|T], H) :- max(T, Max1), H >= Max1.
%max([H|T], Max1) :- max(T, Max1), H < Max1.

%sau
%max([H|T], Max) :- max(T, Max1), H >= Max1, Max = H; 
%					max(T, Max1), H < Max1, Max = Max1.


%verificare daca lista e palindrom
%palindrome([r,e,d,i,v,i,d,e,r]).
%inversare([1,2,3],[],L).
inversare([], X, X).
inversare([H|T], L1, L2) :- inversare(T, [H|L1], L2).
palindrome(L) :- inversare(L, [], L).


%ex 7 remove_duplicates([a, b, a, c, d, d], List).
remove_duplicates([], []).
remove_duplicates([H|T], L) :- member(H, T), remove_duplicates(T, L);
    						  (    not(member(H, T)), remove_duplicates(T, L1), L = [H|L1]).





