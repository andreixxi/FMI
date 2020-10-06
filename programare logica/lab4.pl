% Exercitiul 1

la_dreapta(X, Y) :- X is Y + 1.
la_stanga(X, Y) :- Y is X + 1.
langa(X, Y) :- la_dreapta(X, Y); la_stanga(X, Y).

%casa(Numar,Nationalitate,Culoare,AnimalCompanie,Bautura,Tigari)
solutie(Strada, PosesorZebra, CeBeaPosesorCal) :- 
    Strada = [
             casa(1, norvegian, _, _, _, _), %unde am _ nu cunosc datele/ nu ma intereseaza
             casa(2, _, _, _, _, _),
               casa(3, _, _, _, lapte, _),
               casa(4, _, _, _, _, _),
               casa(5, _, _, _, _, _)],
    %verific fiecare casa daca se afla in strada definita mai sus
    member(casa(_, englez, rosie, _, _, _), Strada),
    member(casa(_, spaniol, _, caine, _, _), Strada),
    member(casa(_, _, verde, _, cafea, _), Strada),
    member(casa(_, ucrainean, _, _, ceai, _), Strada),
    member(casa(X2, _, bej, _, _, _), Strada), la_dreapta(X1, X2),
    member(casa(_, _, _, melci, _, oldGold), Strada),
    member(casa(X5, _, galben, _, _, kools), Strada),
    member(casa(X3, _, _, _, _, ch), Strada),
    member(casa(X4, _, _, vulpe, _, _), Strada), langa(X3, X4),
    member(casa(X6, _, _, cal, _, _), Strada), langa(X5, X6),
    member(casa(_, _, _, _, suc, lucky), Strada),
    member(casa(_, japonez, _, _, _, parliaments), Strada),
    member(casa(X7, _, albastra, _, _, _), Strada), langa(1, X7),
    member(casa(_, PosesorZebra, _, zebra, _, _), Strada),
    member(casa(_, _, _, cal, CeBeaPosesorCal, _), Strada).
    

% Exercitiul 2
% :- include('words.pl'). %scot comentariul pt prima rulare

word_letters(Cuv, Lista) :- atom_chars(Cuv, Lista). %redenumire predicat

% putem calcula listele de frecvente ale literelor din fiecare lista
% predicat frecventa(Litere, Lfrec) Lfrec = [(a, 10),...]

% sterg litera dintr o lista si intorc lista fara litera respectiva
remove_letter(A, [A | L], L).
remove_letter(A, [B | L], [B | L2]) :- A \= B, remove_letter(A, L, L2).

cover([], _).
cover([X | L1], L2) :- remove_letter(X, L2, L2r), cover(L1, L2r).

solution(List, Word, Len) :- word(Word), 
							word_letters(Word, Lw),
							length(Lw, Len), 
							cover(Lw, List).

topSolution(List, Word, Len) :- length(List, LMax),
							solAux(List, Word, LMax, Len).

solAux(List, Word, Lm, Len) :- 
	solution(List, Word, Lm), Len = Lm; 
	not(solution(List, Word, Lm)), Lm1 is Lm - 1, solAux(List, Word, Lm1, Len).

% topSolution([y,c,a,l,b,e,o,s,x], W, L).sss