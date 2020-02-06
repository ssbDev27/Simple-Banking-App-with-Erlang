-module(customer).
-export([setup_customer/4, listen/5, put_result/3]).

%num(L) -> length([X || X <- L, X < 1]).

setup_customer(Pid ,Cust_name, Funds_needed,Banks) ->
	%io:format("HI"),
	Custid = ets:new(Cust_name, [set, protected]),
	Funds_actual = Funds_needed,
	ets:insert(Custid, {Cust_name,Funds_needed}),
	listen(Cust_name, Funds_needed,Banks,Custid,Funds_actual).
	%io:fwrite("List size: ~p\n",[num(Banks)]).
	%ets:new(bank_details, [set, named_table]),
	%ets:insert(bank_details, {Bank_name, Funds}),
	%listen(Cust_name, Funds_needed).

listen(Cust_name,Funds_needed,Banks,Custid,Funds_actual) ->
	
	%io:format("~p~n",Random_Bank),
	if 
		Funds_needed =< 0 ->
			%exit(self(), normal);
			put_result(Cust_name,Funds_actual,Funds_actual-Funds_needed);
		length(Banks) == 0  ->
			%exit(self(), normal);
			put_result(Cust_name,Funds_actual,Funds_actual-Funds_needed);
		true ->
    		B=0
	end,	 


	Random_Bank=rand:uniform(length(Banks)),		
	{Bank,Fund}=lists:nth(Random_Bank, Banks),
	if 
      	Funds_needed >= 50 -> 
      	%io:fwrite("True");
      		Amt=rand:uniform(50);
      	true ->
      		Amt=rand:uniform(Funds_needed)
        	%io:fwrite("False") 
   	end,
    io:format("~p requests a loan of ~p dollar(s) from ~p\n",[Cust_name,Amt,Bank]),
	Bank ! {self(),fund_rqd, Amt},
	receive
		{bank_reply, Reply} ->
		%dog_func(Name), % do something
		if 
      		Reply == "accept" -> 
      			ets:insert(Custid, {Cust_name,Funds_needed - Amt}),
      			io:format("~p approves a loan of ~p dollars from ~p\n",[Bank,Amt,Cust_name]),
        		%io:fwrite("True"), 
        		Banks_new=Banks;
      		true -> 
      			io:format("~p denies a loan of ~p dollars from ~p\n",[Bank,Amt,Cust_name]),
      			Banks_new = lists:delete({Bank,Fund},Banks)
    		end,
   		[{C1,Funds_news}]=ets:lookup(Custid, Cust_name),
   		timer:sleep(20),
		listen(Cust_name,Funds_news,Banks_new,Custid,Funds_actual)
	end.

put_result(Cust_name,Funds_actual,Funds_final) ->
	receive
		{Cust,get_cust_result} ->
			if Funds_final==Funds_actual ->
				io:format("~p has reached the objective of ~p dollar(s). Woo Hoo!\n",[Cust_name,Funds_final]);
			true ->
				io:format("~p was only able to borrow ~p dollar(s). Boo Hoo!\n",[Cust_name,Funds_final])
			end		
	after 1000 ->
		if Funds_final == Funds_actual->
			io:format("~p has reached the objective of ~p dollar(s). Woo Hoo!\n",[Cust_name,Funds_final]);
		true ->
			io:format("~p was only able to borrow ~p dollar(s). Boo Hoo!\n",[Cust_name,Funds_final])
		end,								
	exit(self(), normal)
	end.
