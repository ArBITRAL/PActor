-module(contractors).
-import(elinda,[in/2,out/2]).
-export([wheel_maker/3,seat_maker/2,chassis_maker/2,steering_wheel_maker/2]).


wheel_maker(TS,NoRim,NoTires) ->
    {_,No}=in(TS,{"make-wheel",any}),
    case NoRim < 1 orelse NoTires < 1 of
	true ->
	    io:format("~p forwarding request to peer wheel maker~n",[self()]),
	    out(TS,{"make-wheel",No});
	false ->
	    out(TS,{"wheel-made",{NoRim-1,NoTires-1},No}),
	    io:format("~p made a wheel ~n",[self()]),
	    wheel_maker(TS,NoRim-1,NoTires-1)
    end.



seat_maker(TS,NoSeat) ->
    {_,No}=in(TS,{"make-seat",any}),
    case NoSeat < 1 of
	true ->
	    io:format("~p forwarding request to peer seat maker~n",[self()]),
	    out(TS,{"make-seat",No});
	false ->
	    out(TS,{"seat-made",NoSeat-1,No}),
	    io:format("~p made a seat ~n",[self()]),
	    seat_maker(TS,NoSeat-1)
    end.


chassis_maker(TS,NoChassis) ->
    {_,No}=in(TS,{"make-chassis",any}),
    case NoChassis < 1 of
	true ->
	    io:format("~p forwarding request to peer chassis maker~n",[self()]),
	    out(TS,{"make-chassis",No});
	false ->
	    out(TS,{"chassis-made",NoChassis-1,No}),
	    io:format("~p made a chassis ~n",[self()]),
	    chassis_maker(TS,NoChassis-1)
    end.


steering_wheel_maker(TS,NoSteeringWheel) ->
    {_,No}=in(TS,{"make-steering-wheel",any}),
    case NoSteeringWheel < 1 of
	true ->
	    io:format("~p forwarding request to peer steering wheel maker~n",[self()]),
	    out(TS,{"make-steering-wheel",No});
	false ->
	    out(TS,{"steering-wheel-made",NoSteeringWheel-1,No}),
	    io:format("~p made a chassis ~n",[self()]),
	    steering_wheel_maker(TS,NoSteeringWheel-1)
    end.
