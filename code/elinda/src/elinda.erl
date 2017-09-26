-module(elinda).
-export([new/0,in/2,out/2,peek/1]).

%% return the Pid of the new tuple space
new() ->
    Pid = tuple_space:new(),
    Pid.

%% returns a tuple matching Pattern from tuplespace TS.
%% this operation will block if there is no such tuple.
in(TS,Pattern) ->
    Tuple = tuple_space:in(TS,Pattern),
    Tuple.

%% puts Tuple into the tuplespace TS.
out(TS,Tuple) ->
    tuple_space:out(TS,Tuple).

peek(TS) ->
    MS = tuple_space_element:peek(TS),
    io:format("~nTuple space content ~p ~n",[MS]).
