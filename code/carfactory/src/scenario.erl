-module(scenario).
-import(elinda,[new/0,in/2,out/2]).
-export([start/0,start/1]).

start() ->
    start(3).

start(N) ->
    TS = new(),
    Factory = spawn(manufacture,start,[TS]),
    User = self(),
    io:format("Make car requesting for ~p ... ~n",[N]),
    [out(TS,{Factory,User,"make_car"}) || _ <- lists:seq(1,N)],
    [in(TS,{User,"finish"}) || _ <- lists:seq(1,N)],
    io:format("All Car received ~n").
