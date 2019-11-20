%%%% CSci 117, Lab 9 %%%%
%%%% Joshua Francisco %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 

/* Question 1: Rewrite the function SumList, and the function ScanL, 
where the state is stored in a memory cell when the function is called, 
and a helper function performs the recursive algorithm. */

declare
fun {SumList L}
  A = {NewCell 0}
  fun {SumListH L}
     case L of nil then @A else
	 A := @A + L.1
	{SumListH L.2}
	end
  end
in
   {SumListH L}
end
{Browse {SumList [1 2 3]}}

/* ScanL will be handled similarly, 
except the initial value of your memory cell A will be the Z value passed into the function */
declare
fun {ScanL L Z}
  A = {NewCell Z}
  fun {ScanLH L}
     case L of nil then @A else
	 A := @A + L.1
	{ScanLH L.2}
	end
  end
in
   {ScanLH L}
end
{Browse {ScanL [1 2 3] 0}}

declare
fun{Scan L F Z}
   A = {NewCell Z}
   fun {ScanH L}
       case L of nil then @A else
	 A := @A
	{SumListH L.2}
	end
   end
in
   {ScanH L}
end

/* Question 2: Assuming a memory cell A points to a list of integers, 
write a procedure that sums this list and assigns the sum to A. 
You are only allowed to use a single memory cell in your procedure. */

declare 
A = {NewCell [0 2 4 6 1 3]}
proc {SumL A}
   B = {NewCell @A#0} % Initialize B with some value
   proc {SumLHelp}
      local Y = @B in
      case Y.1 of nil then B:= Y.2 else
     local X = (Y).2 + (Y).1.1 in 
        B := (Y).1.2#X
        end
    {SumLHelp}
      end
      end
    % SumList algorithm code, which only has access to memory cell B, you cannot use A in this procedure
  end
in
   {SumLHelp} % B is now pointing to the sum of @A
 %B:= B.1
 A := @B    % @A is now the value of its former list, summed
end

{SumL A}
{Browse @A} % will print 16




/* Question 3: Assuming a memory cell A points to a list of integers, 
write a procedure that reverses this list and assigns the reversed list to A. 
You are only allowed to use a single memory cell in your procedure. 
This will be handled similarly to Question 2, except your initialization of B will be different. */

declare 
A = {NewCell [0 2 4 6 1 3]}
proc {Reverse A}
   B = {NewCell @A#nil} % Initialize B with some value
   proc {ReverseHelp}
      if @B.1 == nil then B:= @B.2 else
	 local C = @B.1.1|@B.2 in 
	    B := @B.1.2#C
	    end
	{ReverseHelp}
      end
  end
in
   {ReverseHelp} % B is now pointing to the reverse of @A
 A := @B    % @A is now the reverse of its former list
end

{Reverse A}
{Browse @A}


/* Question 4: Rewrite the functional stream that generates the numbers
starting from 0 then adding one up to infinity, (0 1 2 3 …), 
but instead use a local memory cell, such that {Generate} will return a zero argument function, 
and executing that zero argument function gives the next value in the stream. */


% For example,
declare
% A = {NewCell [0 2 4 6 1 3]}
GenF = {Generate [0 1 2 3...}
{GenF} % outputs 0
{GenF} % outputs 1
{GenF} % outputs 2

declare
A = {NewCell 0}
fun {Generate}
  fun {GenHelper}
     A:= @A +1
     @A-1
  end
in
  {GenHelper}
end

GenA = {Generate}
{Browse @A}



/* Question 5: Return to Nested List Flattening. */
/* (a) Use a memory cell to count the number of list creation operations i.e. when ‘|’ is used, 
within the two versions of flattening a nested list from lab 5. */

% I counted the '|' used in Append because both Flatten call append.
						       
declare A B L
A = {NewCell 0}
fun {Flatten1 Xs} 
  case Xs
  of nil then nil
  [] X|Xr andthen {IsList X} then {Append {Flatten1 X} {Flatten1 Xr}} 
  [] X|Xr then A:= @A+1 X|{Flatten1 Xr}  % updated the cell here
  end 
end

fun {Flatten2 Xs}
  proc {FlattenD Xs ?Ds}
    case Xs
    of nil then Y in Ds=Y#Y
    [] X|Xr andthen {IsList X} then Y1 Y2 Y4 in
      Ds=Y1#Y4 
      {FlattenD X Y1#Y2}
      {FlattenD Xr Y2#Y4}
    [] X|Xr then Y1 Y2 in A := @A+1         % updates cell here 
      Ds=(X|Y1)#Y2 {FlattenD Xr Y1#Y2} 
    end 
  end Ys
  in {FlattenD Xs Ys#nil} Ys
end

fun {Append Xs Ys}  
   case Xs of nil then Ys
   %[] X|Xr then A:= @A+1 X|{Append Xr Ys}  %updates cell when append uses '|'
   [] X|Xr then X|{Append Xr Ys}            %this doesn't update cell 
   end                                      %I dont know which one to use.
end

L = [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4]
M = [9 8 7 [6 5 4 [3 2 1]]]
N = [1 2 3 [1 1 3]]
P = [4 [1 2] 3]

O =  [[1 2 3]  [[1] 2 3]  [[1] [2] 3]]

{Browse {Average O}}

/* (b) Verify that your program is correct by running the example [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4] from lab 5, 
along with three other examples of your choosing. */

/*
{Flatten1 Xs} '|' uses:
L = [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4] used '|' 25 times including Append use %%%%%% 12 without counting Append
M = [9 8 7 [6 5 4 [3 2 1]]] used '|' 18 times including Append use %%%%%% 9 without counting Append
N = [1 2 3 [1 1 3]] used '|' 9 times including Append use %%%%%% 6 without counting Append
P = [4 [1 2] 3]  used '|' 6 times including Append use %%%%%% 4 without counting Append

{Flatten2 Xs} '|' uses:
L = [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4] used '|' 12 times 
M = [9 8 7 [6 5 4 [3 2 1]]] used '|' 9 times
N = [1 2 3 [1 1 3]] used '|' 6 times
P = [4 [1 2] 3]  used '|' 4 times

*/

/* (c) Create a function that takes in a list of nested lists, 
and returns the average for both flatting function of list creation operations for these nested lists. 
Test this on the list containing all possible nested lists of 3 elements with nesting depth 2,
 i.e., [[1 2 3]  [[1] 2 3]  [[1] [2] 3] … and give the average for both of the flattening functions. */
B = {NewCell 0}
C = {NewCell 0}
D = {NewCell 0}


fun {Average Xs}
   case Xs of nil then @B %(@C div @D)#(@B div @D)
   [] Y|Yr then {Flatten1 Y} B:= @B+@A
      A:= 0
      {Flatten2 Y} C:= @C + @A 
      D:= @D + 1
      A:= 0
      {Average Yr}
   end
end

%This function does not work.
