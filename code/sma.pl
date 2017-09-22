%problog 2.1.0.19
:- use_module(library(lists)).

men([m1,m2,m3,m4,m5]).
women([w1,w2,w3,m4,m5]).

man(m1).
man(m2).
man(m3).
man(m4).
man(m5).
woman(w1).
woman(w2).
woman(w3).
woman(w4).
woman(w5).

loc(m1,cham).
loc(m2,urb).
loc(m3,aq).
loc(m4,aq).
loc(m5,aq).

loc(w1,cham).
loc(w2,urb).
loc(w3,aq).
loc(w4,urb).
loc(w5,aq).

wall(m1,big).
wall(m2,small).
wall(m3,big).
wall(m4,small).
wall(m5,big).

wall(w1,small).
wall(w2,small).
wall(w3,small).
wall(w4,small).
wall(w5,small).

0.9::pref(m1,loc,cham);0.1::pref(m1,loc,urb).
0.5::pref(m1,wall,small);0.5::pref(m1,wall,big).

0.1::pref(m2,loc,cham);0.9::pref(m2,loc,urb).
0.5::pref(m2,wall,small);0.5::pref(m2,wall,big).

0.1::pref(m3,loc,cham);0.1::pref(m3,loc,urb);0.8::pref(m3,loc, aq).
0.5::pref(m3,wall,small);0.5::pref(m3,wall,big).

0.1::pref(m4,loc,cham);0.1::pref(m4,loc,urb);0.8::pref(m4,loc, aq).
0.5::pref(m4,wall,small);0.5::pref(m4,wall,big).

0.1::pref(m5,loc,cham);0.1::pref(m5,loc,urb);0.8::pref(m5,loc, aq).
0.5::pref(m5,wall,small);0.5::pref(m5,wall,big).

0.9::pref(w1,loc,cham);0.1::pref(w1,loc,urb).
0.5::pref(w1,wall,big);0.5::pref(w1,wall,small).

0.1::pref(w2,loc,cham);0.9::pref(w2,loc,urb);0.0::pref(w2,loc, aq).
0.8::pref(w2,wall,big);0.2::pref(w2,wall,small).

0.1::pref(w3,loc,cham);0.1::pref(w3,loc,urb);0.8::pref(w3,loc, aq).
0.9::pref(w3,wall,big);0.1::pref(w3,wall,small).

0.1::pref(w4,loc,cham);0.1::pref(w4,loc,urb);0.8::pref(w4,loc, aq).
0.9::pref(w4,wall,big);0.1::pref(w4,wall,small).

0.1::pref(w5,loc,cham);0.1::pref(w5,loc,urb);0.8::pref(w5,loc, aq).
0.9::pref(w5,wall,big);0.1::pref(w5,wall,small).


unstable_pair(matched(M1,W1), matched(M2,W2)) :-
	man(M1),woman(W1),man(M2),woman(W2),
	loc(M1,L1),loc(W2,L2),
	pref(M1,loc,L2),pref(W2,loc,M1).
unstable_pair(matched(M1,W1), matched(M2,W2)) :-
	man(M1),woman(W1),man(M2),woman(W2),
	loc(W1,L1),loc(M2,L2),
	pref(W1,loc,L2),pref(M2,loc,L1).

unstable(S) :-
	member(matched(M1,W1), S),
	member(matched(M2,W2), S),
	M1 \== M2,
	unstable_pair(matched(M1,W1),matched(M2,W2)).

marry([],[], []).
marry([M|Ms],[W|Ws], [matched(M,W)|MWs]) :-
	marry(Ms,Ws,MWs).

not(P) :-
	\+ P.

matching(S) :-
	men(M),
	women(W),
	permutation(W,W1),
	marry(M,W1,S),
	not(unstable(S)).

permutation([],[]).
permutation([X|Xs],Ys) :-
	permutation(Xs,Zs),
	insert(X,Zs,Ys).

insert(X,Xs,[X|Xs]).
insert(X,[Y|Ys],[Y|Zs]) :-
	insert(X,Ys,Zs).

query(matching(_)).
