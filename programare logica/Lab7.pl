%Ex1
media(L, S, M) :- media(L, S, M, 0, 0).

media([], _, 0, _, 0).
media([], _, M, Sum, Nr) :- Nr \= 0, M is Sum/Nr.
media([sn(S, N) | L], S, M, Sum, Nr) :- Sum1 is Sum + N, Nr1 is Nr + 1,   %studentul curent este cel cautat
		media(L, S, M, Sum1, Nr1).
media([sn(S1, _) | L], S, M, Sum, Nr) :- S1 \= S, media(L, S, M, Sum, Nr). %studentul curent nu este cel cautat


%Ex2
cuvant(testul,6).
cuvant(usor,4).
cuvant(este,4).
cuvant(ada,3).
cuvant(carte, 5).

exista(N, MC) :- exista(N, MC, []).
exista(0, MC, MC).
exista(N, MC, L) :- cuvant(C, Len), %cuvantul este in baza de cunostinte
		Len =< N, % lungimea cuvantului este mai mica decat N
		not(member(C, L)),  %nu se afla in multime(raspuns)
		N1 is N - Len,  %scad lungimea
		exista(N1, MC, [C | L]). %aplic mai departe>

%Ex 3
%a)
isvar(X) :- member(X,[a,b,c,d,e,f]).

% variabile, zero, plus(E1, E2), ori(E1, E2)

simplifica(X, X) :- isvar(X).
simplifica(zero, zero).
simplifica(plus(zero, X), E) :- simplifica(X, E).
simplifica(plus(X, zero), E) :- simplifica(X, E).
simplifica(ori(zero, _), zero).
simplifica(ori(_, zero), zero).
simplifica(plus(E1, E2), E) :- E1 \= 0, E2 \= 0, 
		simplifica(E1, Es1), simplifica(E2, Es2), 
		((Es1 \= E1; Es2 \= E2), simplifica(plus(Es1, Es2), E);
								E = plus(Es1, Es2)).
simplifica(ori(E1, E2), E) :- E1 \= 0, E2 \= 0, 
		simplifica(E1, Es1), simplifica(E2, Es2), 
		((Es1 \= E1; Es2 \= E2), simplifica(ori(Es1, Es2), E);
								E = ori(Es1, Es2)).

%b)
valoareaux(Mem, E, R) :- isvar(E), member(vi(E, R), Mem).
valoareaux(_, zero, zero).
valoareaux(Mem, plus(E1, E2), R) :- valoareaux(Mem, E1, R1), valoareaux(Mem, E2, R2),
		R is R1 + R2.
valoareaux(Mem, ori(E1, E2), R) :- valoareaux(Mem, E1, R1), valoareaux(Mem, E2, R2),
		R is R1 * R2.
valoare(Mem, E, R) :- simplifica(E, Es), valoareaux(Mem, Es, R).
