%Lab 3
% Crossword puzzle
%Ex 1
word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(enhance,e,n,h,a,n,c,e).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).

crosswd(V1, V2, V3, H1, H2, H3) :- 
    word(V1, _, X1, _, X2, _, X3, _), %variabile anonime unde nu sunt comune
    word(V2, _, Y1, _, Y2, _, Y3, _),
    word(V3, _, Z1, _, Z2, _, Z3, _),
    word(H1, _, X1, _, Y1, _, Z1, _),
    word(H2, _, X2, _, Y2, _, Z2, _),
    word(H3, _, X3, _, Y3, _, Z3, _).


%Ex 2
born(jan, date(20,3,1977)).
born(jeroen, date(2,2,1992)).
born(joris, date(17,3,1995)).
born(jelle, date(1,1,2004)).
born(joan, date(24,12,0)).
born(joop, date(30,4,1989)).
born(jannecke, date(17,3,1993)).
born(jaap, date(16,11,1995)).

%a)
year(X, P) :- born(P, date(_, _, X)).
%b)
before(date(Z1, L1, Y1), date(Z2, L2, Y2)) :- 
    Y1 < Y2;
    Y1 = Y2, L1 < L2;
    Y1 = Y2, L1 = L2, Z1 < Z2.
%c)
older(P1, P2) :- born(P1, D1), born(P2, D2), before(D1, D2).


%Ex3
% Maze

connected(1,2).
connected(3,4).
connected(5,6).
connected(7,8).
connected(9,10).
connected(12,13).
connected(13,14).
connected(15,16).
connected(17,18).
connected(19,20).
connected(4,1).
connected(6,3).
connected(4,7).
connected(6,11).
connected(14,9).
connected(11,15).
connected(16,12).
connected(14,17).
connected(16,19).
    
path(P1, P2) :- connected(P1, P2). %sunt conectate direct
path(P1, P2) :- connected(P1, P3), path(P3, P2). %conectate printr un punct intermediar
%path(1, P).
%path(X, 13).
%path(5, 10).

%punctele formeaza un ciclu
connected2(1,2).
connected2(2,1).
connected2(1,3).
connected2(3,4).
path2(P1, P2) :- connected2(P1, P2). %sunt conectate direct
path2(P1, P2) :- connected2(P1, P3), path2(P3, P2).

%pun punctele vizitate intr o lista
path(P1, P2, L) :- connected2(P1, P2), write(L).
%gasesc primul punct conectat de P1, verific sa nu fie parcurs si caut calea de la p3 la p2
path(P1, P2, L) :- connected2(P1, P3), not(member(P3, L)), path(P3, P2, [P3|L]).   
    
    

% Ex 4
succesor(X, [x|X]).
plus(X1, X2, X3) :- append(X1, X2, X3). %X3 = X1 + X2 (concat)
times([], _, []).
%pt fiecare x din prima lista calculez rez partial al produsului x1*x2 si adaug la rez partial inca un x2
times([x|X1], X2, R) :- times(X1, X2, Rp), plus(X2, Rp, R).
    
   
% Ex 5
element_at([H|_], 1, H). 
element_at([_|T], N, R) :- N > 1, N1 is N-1, element_at(T, N1, R).
    
% Ex 6
/* Animal  database */

animal(alligator). 
animal(tortue) .
animal(caribou).
animal(ours) .
animal(cheval) .
animal(vache) .
animal(lapin) .
    
%genereaza PE RAND(cerinta), deci la rezultat dau next
%daca trb toate deodata puneam intr o lista
mutant(M) :- 
    animal(A1),
    animal(A2),
    A1 \= A2, %animalele sa fie diferite
    name(A1, L1), %liste de litere in ascii
    name(A2, L2),
    append(P1, S1, L1), P1 \= [], S1 \= [], %gasestte toate combinatiile de forma prefix + sufix = l
	append(S1, S2, L2), S2 \= [],
    append(L1, S2, Lm), %lista litere mutant
    name(M, Lm).
    

    
    
    
    
    