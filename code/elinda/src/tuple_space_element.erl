%%%-------------------------------------------------------------------
%%% @author tan duong <tanduong@localhost>
%%% @copyright (C) 2017, tan duong
%%% @doc
%%%
%%% @end
%%% Created : 22 Sep 2017 by tan duong <tanduong@localhost>
%%%-------------------------------------------------------------------
-module(tuple_space_element).

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([in/2,out/2,read/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {tuples,requesters}).

%%%===================================================================
%%% API
%%%===================================================================
in(TS,Pattern) ->
    gen_server:cast(TS,{in,self(),Pattern}).

out(TS,Tuple) ->
    gen_server:cast(TS,{out,Tuple}).

read(TS,Pattern) ->
    gen_server:cast(TS,{read,self(),Pattern}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->

    {ok, #state{tuples=[],requesters=[]}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Msg, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.



%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({in,From,Pattern}, State) ->
    NewState=gettuple({From,Pattern},State),
    {noreply, NewState};
handle_cast({read,From,Pattern}, State) ->
    gettuple2({From,Pattern},State#state.tuples),
    {noreply, State};
handle_cast({out,Tuple}, State) ->
    Tuples = State#state.tuples,
    {Remain,NewRequesters} = answer(State#state.requesters,Tuple),
    {noreply, State#state{tuples = Remain ++ Tuples, requesters = NewRequesters}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


match(any,_) -> true;
match(P,Q) when is_tuple(P), is_tuple(Q)
                -> match(tuple_to_list(P),tuple_to_list(Q));
match([P|PS],[L|LS]) -> case match(P,L) of
                              true -> match(PS,LS);
                              false -> false
                         end;
match(P,P) -> true;
match(_,_) -> false.

gettuple(Asker,State) ->
    gettuple(Asker,State#state.tuples,[],State#state.requesters).

gettuple(Asker,[],Acc,Request) ->
    #state{tuples=Acc,requesters=[Asker|Request]};
gettuple({From,Pattern},[H|T],Acc,Request) ->
    case match(Pattern,H) of
	true ->
	    From ! {ok,H},
	    #state{tuples=Acc++T,requesters=Request};
	false ->
	    gettuple({From,Pattern},T,[H|Acc],Request)
    end.

gettuple2({From,_},[]) ->
    From ! {ok,not_found};
gettuple2({From,Pattern},[H|T]) ->
    case match(Pattern,H) of
	true ->
	    From ! {ok,H};
	false ->
	    gettuple2({From,Pattern},T)
    end.

%%{return remain and requesters}
answer(Requesters,Tuple) ->
    answer(Requesters,Tuple,Requesters).

answer([],Tuple,Acc) ->
    {[Tuple],Acc};
answer(_,[],Acc) ->
    {[],Acc};
answer([{From,Pattern}=H|T],Tuple,Acc) ->
    case match(Pattern,Tuple) of
	true ->
	    From ! {ok,Tuple},
	    answer(T,[],Acc--[H]);
	false ->
	    answer(T,Tuple,Acc)
    end.
