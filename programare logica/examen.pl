% EX 4
suma([], 0). % pt lista vida suma este 0 
suma(Lista, Suma) :- suma(Lista, 0). % initializez suma cu 0
suma([vp(V, P) | L], V, Sum) :- Sum1 is Sum + V,  suma(L, V, Sum1).%cresc suma
    
% EX 5
generare(0, []). % pt n = 0 lista este vida
generare(1, ['a', 'b', 'c']). % n = 1 am lista simpla din a b c
generare(N, ListaAtomi) :- L1 generare(N, append(L1, L2, ListaAtomi))
   