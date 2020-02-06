-module(bank).
-export([setup_bank/3 ,listen/3]).

setup_bank(Pid ,Bank_name, Funds) ->
	%io:format("HI"),
	%ets:new(bank_details, [set, named_table]),
	%ets:insert(bank_details, {Bank_name, Funds}),
	Tabid = ets:new(Bank_name, [set, protected]),
	ets:insert(Tabid, {Bank_name,Funds}),
	listen(Bank_name,Funds,Tabid).

listen(Bank_name,Funds,Tabid) ->
	receive
		{Cust, fund_rqd, Amt} ->
		%dog_func(Name), % do something
		%Funds_new=0,
		if 
      		Amt =< Funds -> 
      			%io:fwrite("True"),
      			ets:insert(Tabid, {Bank_name,Funds - Amt}),
      			Cust ! {bank_reply,"accept"};
      		true -> 
        		%io:fwrite("False"),
        		Cust ! {bank_reply,"reject"}
   		end,
		[{B1,Funds_new}]=ets:lookup(Tabid, Bank_name),
		%io:fwrite("~w",[Funds_new]),
		listen(Bank_name,Funds_new,Tabid)
	after 1000->
		% receive
		% {Banky, get_bank_result} ->
		io:format("~p has ~p dollar(s) remaining.\n",[Bank_name,Funds])
	end.

