% hello world program
-module(money).
-export([start/0, start_bank_calls/1, start_customer_calls/2]).



start_bank_calls({Bank_name, Funds}) -> 
    Bid = spawn(bank, setup_bank, [self(),Bank_name, Funds]),
    %User_list = [],
    %User_list = [Pid | User_List],
    %Bankhi=Bank_name++"nf",
    register(Bank_name, Bid),
    %io:format("~p  ~p~n",[whereis(Bank_name),Bank_name]),
    io:format("~p: ~p~n",[Bank_name, Funds]).

start_customer_calls({Customer_name, Funds_needed},Banks) -> 
    Cid = spawn(customer, setup_customer, [self(), Customer_name, Funds_needed, Banks]),
    % register(Caller, spawn(project, client, [self(), Caller, Friends])),
    io:format("~p: ~p~n",[Customer_name, Funds_needed]).


start() ->
   %Lst1 = [], 
   %Map1 = #{42 => value_two}, 
   %io:fwrite("~p~n",[maps:put(43,hfjf,Map1)]),
   %io:fwrite("~p~n",[maps:get(42,Map1)]),
   %set_pid(Map1),
   %io:fwrite("~p~n",[maps:get("bank_name",Map1)]),

    {ok, Banks} = file:consult("banks.txt"),
    io:format("~n** Banks and financial resources **~n"),
    %io:fwrite("~p",P).
    %erlang:insert_element(Map1,Banks),
    %io:format("~p: ~p~n",Banks),
    %lists:foreach(fun start_bank_calls/1, Banks).
    lists:foreach(fun start_bank_calls/1, Banks),

    {ok, Calls} = file:consult("customers.txt"),
    io:format("~n** Customers and loan objectives **~n"),
    %io:fwrite("~p",P).
 
    %lists:foreach(fun start_customer_calls/1, Calls),
    [start_customer_calls(H,Banks) || H <- Calls].
      %master([]).
 
  