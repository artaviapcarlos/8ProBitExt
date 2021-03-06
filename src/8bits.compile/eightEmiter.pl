/*
EIF400 loriacarlos@gmail.com
*/

:-['eightParser']
.

testEmiter :-
    testParser(P),
	genCode(P)
.


genCodeToFile(File, P) :-
   open(File, write, Out),
   genCode(Out, P),
   close(Out)
.
genCode(P) :- genCode(user_output, P)
.
genCode(Out, eightProg(L)) :- !, genCodeList(Out, L)
.
genCode(Out, fun(N, F, B)) :- !,
    format(Out, 'function ', []),
    genCode(Out, N),
	genCode(Out, F),
	genCode(Out, B)
.
genCode(Out, formals(L)) :- !,
     format(Out, '(', []),
     genCodeList(Out, L, ', '),
	 format(Out, ')', [])
.
genCode(Out, body(L)) :- !,
   format(Out, '{', []),
   genCodeList(Out, L, ' '),
   format(Out, '}', [])
.
genCode(Out, atom(N)) :- !, format(Out, '~a ', [N])
.
genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, statement(N)) :- !,
    genCodeList(Out, [N])
. %falta algo?

genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])

.
genCode(Out, empty) :- !,  format(Out, '; ', [])
.

genCode(Out, assign(I, E)) :-  !,
   genCode(Out, operation(oper('='), I, E))

.
genCode(Out, return(E)) :- !, format(Out, 'return ', []),
                              genCode(Out, E)
.
genCode(_, E ) :- throw(E).

genCodeList(Out, L) :- genCodeList(Out, L, ' ')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X),
                                format(Out, '~a', [Sep]),
                                genCodeList(Out, [Y | L], Sep)
.

genCodePrint(Out,N) :- !, %genCode para print_string, print_boolean, print_number
    format(atom(Out),'console.log(~w);', [N])
.
