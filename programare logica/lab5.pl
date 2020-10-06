% EX 1
is_var(a). is_var(b). is_var(c). is_var(d).

% is_var(X) :- member(X, [a, b, c, d, e, f]).

% operatorii si, negatie, sau, implica
:- op(620, xfy, si). 
:- op(610, fy, nu).
:- op(630, xfy, sau).
:- op(640, xfy, imp).


% EX 2
% formula(a si (nu b sau c)).
% formula(a si nu b sau c).
% formula(a si nu b sau). aici da eroare de sintaxa

formula(F) :- is_var(F).
formula(nu F) :- formula(F). %nu F este corecta daca F este corecta
formula(F1 si F2) :- formula(F1), formula(F2). %f1 si f2 sunt corecte
formula(F1 sau F2) :- formula(F1), formula(F2).
formula(F1 imp F2) :- formula(F1), formula(F2).


% dupa rularea 'test.' la erorile de sintaxa de mai sus returneaza direct false
test :- catch(read(X), Error, false), X.


% EX 3
find_vars(F, V, Vfin) :- is_var(F), (not(member(F, V)), Vfin = [F|V]; Vfin = V), !.
			%daca f este variabila si nu se afla in V o adaug in vfinal
find_vars(nu F, V, Vfin) :- find_vars(F, V, Vfin).
find_vars(F1 si F2, V, Vfin) :- find_vars(F1, V, Vaux), find_vars(F2, Vaux, Vfin).
					% ce e in V combinat cu ce e in F1 distinct apoi adauga ce e distnict din F2 wtf
find_vars(F1 sau F2, V, Vfin) :- find_vars(F1, V, Vaux), find_vars(F2, Vaux, Vfin).
find_vars(F1 imp F2, V, Vfin) :- find_vars(F1, V, Vaux), find_vars(F2, Vaux, Vfin).


% EX 4
% [[1], [0]] -> [0, 1], [1, 1], [0, 0], [1, 0] -> [0, 0, 1], [1, 0, 1] ...
all_assigns(0, [[]]).
all_assigns(N, List) :- M is N - 1, all_assigns(M, Laux),  transform(Laux, List), !.

transform([], []).
transform([H|T], [ [0|H], [1|H] | Tr]) :- transform(T, Tr). % WTFFFFFFFFFFFFFFF =)))))))))))))))))))))))



% EX 5
table_nu(0, 1).
table_nu(1, 0).

table_sau(0, 0, 0).
table_sau(0, 1, 1).
table_sau(1, 0, 1).
table_sau(1, 1, 1).

table_si(0, 0, 0).
table_si(0, 1, 0).
table_si(1, 0, 0).
table_si(1, 1, 1).

table_imp(0, 0, 1).
table_imp(0, 1, 1).
table_imp(1, 0, 0).
table_imp(1, 1, 1).


% EX 6
lookup(F, [F|Var], [Val|A], Val).
lookup(F, [_|Var], [_|A], Val) :- lookup(F, Var, A, Val).

truth_value(F, Var, A, Val) :- is_var(F), lookup(F, Var, A, Val).
truth_value(nu F, Var, A, Val) :- truth_value(F, Var, A, Val1), table_nu(Val1, Val). 
truth_value(F1 si F2, Var, A, Val) :- truth_value(F1, Var, A, Val1),
									  truth_value(F2, Var, A, Val2),
									  table_si(Val1, Val2, Val).
truth_value(F1 sau F2, Var, A, Val) :- truth_value(F1, Var, A, Val1),
									  truth_value(F2, Var, A, Val2),
									  table_sau(Val1, Val2, Val).
truth_value(F1 imp F2, Var, A, Val) :- truth_value(F1, Var, A, Val1),
									  truth_value(F2, Var, A, Val2),
									  table_imp(Val1, Val2, Val).


% EX 7
all_values(F, Var, [], []).
all_values(F, Var, [A|La], [Val|Lval]) :- all_values(F, Var, La, Lval), truth_value(F, Var, A, Val),!.



% EX 8
values_all_assigns(F, Lval) :- 
	formula(F),
	find_vars(F, [], Var),
	length(Var, Len),
	all_assigns(Len, La),
	all_values(F, Var, La, Lval).


is_taut(F) :- values_all_assigns(F, Lval), all_1(Lval) write('este tautologie');
														write('nu este tautologie'), !.
all_1([]).
all_1([1|L]) :- all_1(L). %false daca am cel putin un 0