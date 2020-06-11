-module(sequential_server).
-compile(export_all).
-import(lists, [reverse/1]).


receive_data(Socket, SoFar) ->
    receive
	{tcp,Socket,Bin} ->
	    receive_data(Socket, [Bin|SoFar]);
	{tcp_closed,Socket} ->
	    list_to_binary(reverse(SoFar))
    end.



nano_client_eval(P) ->
    {ok, Socket} = 
	gen_tcp:connect("localhost", 2345,
			[binary, {packet, 4}]),
    ok = gen_tcp:send(Socket, P),
    receive
	{tcp,Socket,Bin} ->
	    io:format("Клієнт відправив ~p~n",[P]),
	    Val = (Bin),
	    io:format("Результат виконання сортування ~p~n",[Val]),
	    gen_tcp:close(Socket)
    end.



start_seq_server() ->
    {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},
					 {reuseaddr, true},
					 {active, true}]),
    seq_loop(Listen).

seq_loop(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    loop(Socket),
    seq_loop(Listen).


loop(Socket) ->
    receive
	{tcp, Socket, Bin} ->
	    io:format("Сервер прийняв ~p~n",[Bin]),
	    P =(Bin),
	    io:format("Сервер зчитав  ~p~n",[P]),
		L = binary_to_list(P),
	    Reply = {insertionsort(L)},
		file:write_file("result.txt", io_lib:fwrite("~p.\n", [Reply])),
	    io:format("Сервер відправив результат ~p~n",[Reply]),
	    gen_tcp:send(Socket, Reply), 
	    loop(Socket);
	{tcp_closed, Socket} ->
	    io:format("Server socket closed~n")
    end.


insertionsort([]) -> [];
insertionsort(List) ->
   insertionsort(List, []).
 
insertionsort([], Sorted) -> Sorted;
insertionsort([Head | Tail], Sorted) ->
   insertionsort(Tail, insert(Head, Sorted)).

insert(X, []) -> [X];
insert(X, [Head | Tail] = Rest) ->
   if
     X =< Head -> [X | Rest];
     true -> [Head | insert(X, Tail)]
   end.





