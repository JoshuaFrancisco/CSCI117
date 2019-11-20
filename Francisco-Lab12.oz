% Lab 12
% Joshua Francisco
% 12/28/18

% Part 1 (4 pts)
% 1. Figure 7.3 on Page 500 defines the Function New, which creates objects from classes, and takes in an initial message.
fun {New Class Init}
	Fs={Map Class.attrs fun {$ X} X#{NewCell _} end}
	S={List.toRecord state Fs}
	proc {Obj M}
		{Class.methods.{Label M} M S}
	end
        in
	{Obj Init}
	Obj
end
% a) Write a function New2, which takes a class as input, and creates an object without an initial message.
fun {New Class}
	Fs={Map Class.attrs fun {$ X} X#{NewCell _} end}
	S={List.toRecord state Fs}
	proc {Obj M}
		{Class.methods.{Label M} M S}
	end
        in
	Obj
end
% b) Write a function New3, which takes a class as input, and creates an object where the initial message is always the zero-arity record init.
(Hint: Write the function for (a) and (b) in terms of New)
fun {New Class Init}
	Init=%zero arity record
	Fs={Map Class.attrs fun {$ X} X#{NewCell _} end}
	S={List.toRecord state Fs}
	proc {Obj M}
		{Class.methods.{Label M} M S}
	end
        in
	{Obj Init}
	Obj
end
% 2. Figure 7.6 on Page 510 defines the class Account, and page 511 defines a subclass LoggedAccount.
class Counter
	attr val
	meth init(Value)
	val:=Value
	end
	meth browse
	{Browse @val}
	end
	meth inc(Value)
	val:=@val+Value
	end
end
local
	proc {Init M S}
	init(Value)=M in (S.val):=Value
	end
	proc {Browse2 M S}
	{Browse @(S.val)}
	end
	proc {Inc M S}
	inc(Value)=M in (S.val):=@(S.val)+Value
	end
in
	Counter=c(attrs:[val]
	methods:m(init:Init browse:Browse2 inc:Inc))
end

class Account
	attr balance:0
	meth transfer(Amt)
	balance:=@balance+Amt
	end
	meth getBal(Bal)
	Bal=@balance
	end
	meth batchTransfer(AmtList)
	for A in AmtList do {self transfer(A)} end
	end
end
% a) The class Counter from Page 498 is redefined on Page 499 without syntactic support. Do the same with the Account.
local
	proc {Transfer M S}
	transfer(balance)=M in (S.balance):=@(S.balance)+Amt
	end
	proc {GetBal M S}
	getBal(balance)=M in Balance:=@(S.balance)
	end
	proc {BatchTransfer M}
	for M in AmtList do {self transfer(M)} end
	end
in
	Account=a(attrs:[balance]
	methods:m(transfer:Transfer getBal:GetBal batchTransfer:BatchTransfer))
end
% b) Implement the LobObj used in LoggedAccount, where LobObj is an instance of the class LogTransfer. LogTransfer is a class with a single attribute log, which is a list containing the transfer values in order, and a single method addEntry, which takes transfer(Amt) as input, adds Amt to the end of log, and displays Amt with a Browse statement.
class LoggedAccount from Account
	meth transfer(Amt)
	{LobObj addentry(transfer(Amt))}
	balance:=@balance+Amt
	end
	meth addEnd(Amt)
	{LobObj addentry(addEnd(Amt))}
	Bal=@balance
	end
	meth display(Amt)
	{LobObj addentry(display(Amt))}
	{Browse @Amt}
	end
end
% c) Test the complete code and run several batchTransfer calls for an instance of Account and an instance of LoggedAccount. What is the behavior of batchTransfer of both objects? Answer this in terms of dynamic versus static binding as described on Page 512.

% batchTransfer in Account uses dynamic binding while batchTransfer in LoggedAccount uses static binding. Because batchTransfer in Account uses dynamic binding and runs several times, the overriding is taken into account in matching M. batchTransfer in LoggedAccount does not take overriding into account since it is a subclass.

% 3. Using flexible argument lists with variable reference to method head from Page 505, extend the class Counter from Page 498 in the following way: change the attribute val to a record of counters (memory cells) with feature names from a ... m, i.e., val(a:(memory cell) b:(memory cell) ... m(memory cell)). Change the method inc, to a method which takes in a flexible argument list that starts at a i.e. inc(a:A ...)=M. This method should loop through the features of M which correspond to the features of val, and increment the corresponding memory cells with e.g., M.a (the value corresponding to the feature in M).

% Example:
% Count is a Counter object with val(a:0 b:0 ... m:0)
% {Count inc(a:5 d:10)}
% Count now has val(a:5 b:0 c:0 d:10 ... m:0)
class Counter
	attr val
	attr Count:val(a:0 b:0 ... m:0)
	meth init(Value)
	val:=Value
	end
	meth browse
	{Browse @val}
	end
	meth inc(Count)
	val:=@val+Count
	end
end
% 4. Using the wrapping methods described on Page 522-523 for TraceNew and TraceNew2, write a function that wraps an input object inside the class AttrCount. That is, write a function from objects to object, where Attr has the same structure as TraceNew2, but also contains a single attribute count, an additional method browseCount (Browsing the value of count), and modifies the otherwise case to increment the value of count for each time a Message is passed to the wrapped object.
fun {BrowseCount Class AttrCount}
	Count={New Class AttrCount}
	BCount={NewName}
	class Attr
		meth !BCount {Browse @Count} end
		meth otherwise(M)
			{Browse entering({Label M})}
			{Obj M}
			Count:=Count+1
			{Browse exiting({Label M})}
		end
	end
in {New Attr BCount} end
% Part 2 (4 pts)
% Convert the C++ code lab12Market.cpp on Piazza into Oz. Run several tests and include them in your assignment file, to show that the code executes properly.

% Important concepts:
% - Static member variables --> in lab example
% - Protected methods --> Page 515-516
% - Private methods --> Page 514
% - All instances of 'this->' can be ignored.

%NOTE: DID NOT INCLUDE AND TESTING

attr CashierNum:0

class Market
%protected
	attr apples
	attr oranges
	attr bananas
	attr pineapples
	attr profits
	attr cashiers
	attr transactions

	meth getApples
		ret @apples
	end
	meth getOranges
		ret @oranges
	end
	meth getBananas
		ret @bananas
	end
	meth getProfits
		ret @profits
	end
	meth getCashiers
		ret @cashiers
	end
	meth getTransactions
		ret @transactions
	end

	meth updateApples(X)
		apples:=@apples-X
	end
	meth updateOranges(X)
		oranges:=@oranges-X
	end
	meth updateBananas(X)
		bananas:=@bananas-X
	end
	meth updatePineapples(X)
		pineapples:=@pineapples-X
	end
	meth updateProfits(X)
		profits:=@profits+X
	end
	meth updateCashiers(X)
		cashiers:=@cashiers+X
	end
	meth updateTransactions(X)
		transactions:=@transactions+X
	end

%public
	meth displayAll
		{Browse 'Apples ' @apples}
		{Browse 'Oranges ' @oranges}
		{Browse 'Bananas ' @bananas}
		{Browse 'Pineapples ' @pineapples}
		{Browse 'Profits ' @profits}
		{Browse 'Transactions ' @transactions}
	end

	meth Market end
end

@apples:=100
@oranges:=130
@bananas:=218
@pineapples:=231
@cashiers:=0
@profits:=0
@transactions:=0

class Cashier
%private
	meth getProfits
		ret @profits1
	end
	meth getTransactions
		ret @transactions1
	end
	meth updateProfits(X)
		profits1:=@profits1+X
	end
	meth updateTransactions(X)
		transactions1:=@transactions1+X
	end

%protected
	attr profits1
	attr transactions1
	attr id

%public
	meth Cashier
		profits1:=0
		transactions1:=0
		updateCashiers(1)
		id:=@CashierNum+1
	end

	meth displayAll
		{Browse 'Cashier ' @id}
		{Browse 'Profits ' @profits1}
		{Browse 'Transactions ' @transactions1}
		{Browse 'Market'}
		Market.displayAll
		Market.getCashiers(X)
		{Browse 'Cashier Count ' X}
	end
end

Cashier cash1, cash2, cash3
cash1.displayAll
bool Complete
cash1.makePurchase(apple, 2, Complete)
cash2.makePurchase(apple, 1, Complete)
cash3.makePurchase(apple, 3, Complete)
cash1.displayAll
cash2.displayAll
cash3.displayAll