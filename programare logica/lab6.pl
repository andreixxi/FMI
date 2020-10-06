% EX 1
%scrieti un predicat num_aparitii/3 care determina nr de aparitii al unui element intr o lista
%num_aparitii(L, X, R)

num_aparitii([], _, R, R). %pt lista vida, nu cont ce element caut, apare de 0 ori
num_aparitii([H|T], X, R, Rf) :- H = X, R1 is R + 1, num_aparitii(T, X, R1, Rf).
num_aparitii([H|T], X, R, Rf) :- H \= X, R1 = R, num_aparitii(T, X, R1, Rf).

num_aparitii(L, X, R) :- num_aparitii(L, X, 0, R).

num_aparitii([], _, 0).
num_aparitii([H|T], X, R) :- num_aparitii(T, X, R1), (H = X, R is R1 + 1; H \= X, R = R1), !.


% EX 2
lista_cifre(X, [X]) :- X =< 9.
lista_cifre(N, Lf) :- N >= 10, C is N mod 10, M is N div 10, lista_cifre(M, L), append(L, [C], Lf).


% EX 3
permuta([], []).
permuta([H|T], L) :- append(T, [H], L). % duce head la coada

%permut lista curenta si obtin permutarea curenta
lista_permutari(Lc, Li, [Pc|Lp]) :- 
		permuta(Lc, Pc), 
		Pc \= Li, lista_permutari(Pc, Li, Lp).
lista_permutari(Lc, Li, [Pc]) :- 
		permuta(Lc, Pc), 
		Pc = Li.

% il pierd pe P la permutare deci il adaug din prima
listpermcirc(L, [P|Lp]) :- permuta(L, P), lista_permutari(P, L, Lp).


% EX 4
% a) 
elimina([], _, []). 
elimina([X|T], X, R) :- elimina(T, X, R).
elimina([X|T], Y, [X|R]) :- X \= Y, elimina(T, Y, R).

%b)
multime([], []).
multime([H|T], [H|M]) :- elimina(T, H, T1), multime(T1, M).

%c)
emultime(L) :- multime(L, L).


% EX 5
%a)
inters([], _, []).
inters([H|T], L, R) :- inters(T, L, R1), 
    	 (member(H, L), R = [H|R1]; not(member(H, L)), R = R1).

%b)
diff([], _, []).
diff(L, [], L).
diff([H|T], L, R) :- diff(T, L, R1), 
    	(member(H, L), R = R1; not(member(H, L)), R = [H|R1]).

%c)
prod_cartezian([], _, []).
prod_cartezian([H|T], L, R) :- perechi(H, L, L1), prod_cartezian(T, L, L2), append(L1, L2, R).

perechi(_, [], []).
perechi(X, [H|T], [(X, H) | Rt]) :- perechi(X, T, Rt).


% EX 6
% a)
srd(nil, []).
srd(arb(R, S, D), L) :- srd(S, Ls), srd(D, Ld), append(Ls, [R | Ld], L).

rsd(nil, []).
rsd(arb(R, S, D), L) :- rsd(S, Ls), rsd(D, Ld), append([R | Ls], Ld, L).

sdr(nil, []).
sdr(arb(R, S, D), L) :- sdr(S, Ls), sdr(D, Ld), append(Ls, Ld, L1), append(L1, [R], L).


% b)
frunze(nil, []).
frunze(arb(R, nil, nil), [R]).
frunze(arb(_, S, D), L) :- frunze(S, Ls), frunze(D, Ld), append(Ls, Ld, L). 

%asa nu append(frunze(S), frunze(D), L). predicatele intorc valori boolene 