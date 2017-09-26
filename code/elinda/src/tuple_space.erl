-module(tuple_space).
-export([new/0,in/2,out/2]).

new() ->
    {ok,Pid} = tuple_space_element:start_link(),
    Pid.

in(TS,Pattern) ->
    tuple_space_element:in(TS,Pattern),
    Msg = receive
     	      {ok,Respone} ->
     		  Respone
     	  end,
    Msg.

out(TS,Tuple) ->
    tuple_space_element:out(TS,Tuple).
