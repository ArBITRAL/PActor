-module(manufacture).
-import(elinda,[in/2,out/2]).
-export([make_car/1,start/1]).

start(TS) ->
    NoRim = 2,
    NoTires = 2,
    NoSeat = 2,
    NoChassis = 2,
    NoSteeringWheel = 4,
    [spawn(contractors,wheel_maker,[TS,NoRim,NoTires]) || _ <- lists:seq(0,5)],
    [spawn(contractors,seat_maker,[TS,NoSeat]) || _ <- lists:seq(0,2)],
    [spawn(contractors,chassis_maker,[TS,NoChassis]) || _ <- lists:seq(0,1)],
    [spawn(contractors,steering_wheel_maker,[TS,NoSteeringWheel])  || _ <- lists:seq(0,2)],
    make_car(TS).

make_car(TS) ->
    Self = self(),
    {_,User,_} = in(TS,{Self,any,"make_car"}),
    io:format("Request received from User ~p by Manufacture ~p ....~n",[User,Self]),
    [out(TS,{"make-wheel",I}) || I <- lists:seq(0,3)],
    [out(TS,{"make-seat",I}) || I <- lists:seq(0,1)],
    out(TS,{"make-chassis",1}),
    out(TS,{"make-steering-wheel",1}),
    Wno = in(TS,{"wheel-made",any,any}),
    io:format("all wheel made on the current car~n"),
    Sno = in(TS,{"seat-made",any,any}),
    io:format("all seat made on the current car~n"),
    Cno = in(TS,{"chassis-made",any,any}),
    io:format("all chassis made on the current car~n"),
    SWno = in(TS,{"steering-wheel-made",any,any}),
    io:format("all steering wheel made on the current car~n"),
    out(TS,{User,"finish"}),
    make_car(TS).
