:- use_module(library(lists)).

men([m1,m2,m3]).
women([w1,w2,w3]).

0.4::choice(m1, w1, w2).
0.6::choice(m1, w2, w1).
0.6::choice(m1, w2, w3).
0.4::choice(m1, w3, w2).
0.2::choice(m1, w1, w3).
0.8::choice(m1, w3, w1).

0.0::choice(m2, w1, w2).
1.0::choice(m2, w2, w1).
0.5::choice(m2, w2, w3).
0.5::choice(m2, w3, w2).
1.0::choice(m2, w1, w3).
0.0::choice(m2, w3, w1).

0.0::choice(m3, w1, w2).
1.0::choice(m3, w2, w1).
0.5::choice(m3, w2, w3).
0.5::choice(m3, w3, w2).
1.0::choice(m3, w1, w3).
0.0::choice(m3, w3, w1).

0.0::choice(w1, m1, m2).
1.0::choice(w1, m2, m1).
1.0::choice(w1, m2, m3).
0.0::choice(w1, m3, m2).
1.0::choice(w1, m1, m3).
0.0::choice(w1, m3, m1).

0.8::choice(w2, m1, m2).
0.2::choice(w2, m2, m1).
1.0::choice(w2, m2, m3).
0.0::choice(w2, m3, m2).
1.0::choice(w2, m1, m3).
0.0::choice(w2, m3, m1).

0.2::choice(w3, m1, m2).
0.8::choice(w3, m2, m1).
1.0::choice(w3, m2, m3).
0.0::choice(w3, m3, m2).
1.0::choice(w3, m1, m3).
0.0::choice(w3, m3, m1).

unstable_pair(matched(M1,W1), matched(M2,W2)) :-
	choice(M1,W2,W1),choice(W2,M1,M2).
unstable_pair(matched(M1,W1), matched(M2,W2)) :-
	choice(W1,M2,M1),choice(M2,W1,W2).

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

%% matching([matched(m1,w1), matched(m2,w2), matched(m3,w3)]):	0.052
%% matching([matched(m1,w1), matched(m2,w3), matched(m3,w2)]):	0
%% matching([matched(m1,w2), matched(m2,w1), matched(m3,w3)]):	0.48
%% matching([matched(m1,w2), matched(m2,w3), matched(m3,w1)]):	0
%% matching([matched(m1,w3), matched(m2,w1), matched(m3,w2)]):	0
%% Matching([matched(m1,w3), matched(m2,w2), matched(m3,w1)]):	0.2496
