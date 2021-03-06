%%%% CSci 117, Lab 2 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 


% 1. Write a more effecient version of the function Comb from section 1.3
%% (a) use the definition   n choose r = n x (n-1) x ... x (n-r+1) / r x (r-1) x ... x 1
%% calculate the numerator and denominator separately, then divide the results
%% note: the solution is 1 when r = 0

% Program Code
declare Num Denom Comb
fun {Num N R}
   if N == R then N
   else N * {Num (N-1) R} end
end
fun {Denom N}
   if N == 0 then 1
   else N * {Denom (N-1)} end
end
fun {Comb N R}
   {Num N (N-R+1)} div {Denom N}
end

%% (b) use the identity   n choose r = n choose (n-r) to further increase effeciency 
%% So, if r > n/2 then do the calculation with n-r instead of r

% Program Code


% 2. Based on the example of a correctness proof from section 1.6, write a correctness
% proof for the function Pascal from section 1.5. 

% Example correctness proof for Fact from section 1.6
/* 
  Proof of correctness for Fact N by induction on N:
    Base case (N = 0), {Fact 0} retruns the correct answer, namely 1

    Inductive Hypothesis: {Fact K-1} is correct
    Inductive case (N=K): the 'if' instruction takes the 'else' case, and calclulates
      K*{Fact K-1}. By the IH, {Fact K-1} is correct. Therefore, {Fact N} also returns 
      the correct solution.
*/
 
%% (a) Write the correctness proof for the function Pascal from section 1.5, assuming 
%% both the ShiftLeft and ShiftRight functions are correct.

/*
								   Your Proof
								   
Proof of correctness for Pascal N by induction on N:
Base case (N = 1), {Pascal 1} returns 1

Inductive Hypothesis: {Pascal K+1} is correct
Inductive case (N=K): the 'if' instruction takes the 'else' case, and shifts {Pascal N-1} both left and right. By the inductive hypothesis, {Pascal K+1} is correct. Therefore {Pascal N} also returns the correct solution.
*/

% 3. Write a lazy function (section 1.8) that generates the list 
%        N | N-1 | N-2 | ... | 1 | 2 | 3 | ...    where N is a positive number
% Hint: you cannot do this with only one argument

% Program Code
 /*
%%%%%%%Other Older Version%%%%%%%%			
declare
fun lazy {Ints N P}
   if P == 1 then (N | {Ints N+1 1}) else {Helper N} end
end
fun {Helper A}
   if A == 0 then ({Ints 0 1}) else( A | {Helper A-1}) end
end
%Execution
declare
L = {Ints 2 0}
case L of A|B|C|D|E|F|_ then {Browse A} {Browse B} {Browse C} {Browse D} {Browse E} {Browse F} end
*/
declare
fun lazy {Ints N}
   if N >= 0 then (N | {Ints N-1}) else ((N*(0-1)) | {Ints N-1}) end
end

{Browse {Ints 0}}

% 4. Write a procedure (proc) that displays ({Browse}) the first N elements of a List
% and run this procedure on the list created in Q3

% Program Code

declare
First L N
proc {First L N}
   if N > 1 then ({Browse L.1} {First (L.2)(N-1)}) else {Browse L.1} end
end

{First {Ints 5} 10}

%Browser Input and Output
%Input {First {Ints 5} 10}
%Output 5,4,3,2,1,0,1,2,3,4

% 5. Using the function Pascal from section 1.9, explore the possibilities of higher-order
% programming by using the following functions as input: multiplication, subtraction, XOR,
% adjusted multiplication: Adjmult X Y = (X+1)*(Y+1), and an operation of your own.
% Display the first 5 rows using   for I in 1..10 do {Browse {GenericPascal Op I}} end
% where Op is the operation you have defined, e.g. multiplication.

% Program Code (for your own operation)

declare ShiftLeft ShiftRight OpList GenericPascal

fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else [0] end
end

fun {ShiftRight L} 0|L end

fun {GenericPascal Op N}
   if N==1 then [1]
   else L in
      L={GenericPascal Op N-1}
      {OpList Op {ShiftLeft L} {ShiftRight L}}
   end
end

fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
     {Op H1 H2}|{OpList Op T1 T2}
      end
   else nil end
end

fun {Add X Y} X+Y end
fun {Mult X Y} XY end
fun {Sub X Y} X-Y end
fun {XOR X Y} if X==Y then 0 else 1 end end
fun {Adjmult X Y} (X+1)(Y+1) end
fun {Addmult X Y} (X+Y)*Y end

for I in 1..10
do {Browse {GenericPascal XOR I}} end
/*
Describe the Browser output for the 5 operations, and give some insight as to why they
outputed the values they did.
%For the Multiply operation, the triangle starts with a 1 then a bunch of 0's follow after . This is because the program is multiplying by zero.
%For the subtraction operation, the triangle is normal but every other number in each row is negative,
%This is because when shifting, the values are sometimes subtracted by 0 thus leading to a negative number.
%For the XOR operation, the triangle is is divided of 1s and 0s with each other row being 1s or 0s respectively. This is because the XOR operation checks whether the value within the triangle is odd or even.
%For the Adjmult operaiton, the values located in the middle of each row of the triangle contain a large value. This is because the operation is basically increasing exponentially.
%For my operation which combines the two operations of Addition and Multiplication, it looks similar to the multiplication operation but with 1 at the end of each row. This is because the y's value is equal to the tip of the triangle with it being (0*1)+1.
*/


% 6. local X in 				local X in
%       X=23						  X={NewCell 23}
%       local X in 				  X:=44
%          X=44					  {Browse @X}
%       end						end
%        {Browse X}				
%       end
% What does Browse display in each fragment? Explain.

/*
Your answer: For the first block of code Browse X will display 23 because local X in X=44
is declared in its own scope whereas Browse X is included in local X in X=23's scope.
For the second block of code Browse @X will access the contents of X={NewCell 23} whereas just Browse X will return {Cell}.


*/


% 7. Define functions {Accumulate N} and {Unaccumulate N} such that the output of 
% {Browse {Accumulate 5}} {Browse {Accumulate 100}} {Browse {Unaccumulate 45}}
% is 5, 105, and 60. This will be implemeted using memory cells (section 1.12).

% Program Code 
declare
Accumulate Unaccumulate
C = {NewCell 0}
proc {Accumulate N}
   (C:=@C+N)
   {Browse @C}
end
proc {Unaccumulate N}
   (C:=@C-N)
   {Browse @C}
end

{Accumulate 5}
{Accumulate 100}
{Unaccumulate 45}
% Program Code 
