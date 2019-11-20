%%%% CSci 117, Lab 4 %%%%
%%%% Joshua Francisco %%%%
% 1. Section 2.4 explains how a procedure call is executed. Consider the following procedure MulByN:

declare MulByN N in 
N=3
proc {MulByN X ?Y}
    Y=N*X
end

% together with the call {MulByN A B}. Assume that the environment at the call contains {A → 10, B → x1}. When the
% procedure body is executed, the mapping N → 3 is added to the environment. Why is this a necessary step? In 
% particular, would not N → 3 already exist somewhere in the environment at the call? Would not this be enough to  
% ensure that the identifier N already maps to 3? Give an example where N does not exist in the environment at the 
% call. Then give a second example where N does exist there, but is bound to a different value than 3.

/*
Your answer
N is needed to complete the functions operation because it is included. Without N, X would be assigned to Y. Ex.) X=10, without N the fuction MulByN would be Y=N AKA Y=10 so the proc would output 10. On the other hand, changing the other value of 4 would change the value of Y upon calling the proc. Instead of 3*10 where N = 3 and X = 10. The instruction would 4*10 where N = 4 and X = 10.
*/

/* BASIC FACTORIAL DEFINITION
fun{fact N}
   if N==0
   else N*{fact N}
   end

declare fact
fact = proc ( $ N R }
local C in
   C= N==0
   if C then R = 1
   else
      local N1 in
	 local N2 in
	    N1 = N-1
	    {fact N1 R1}
	    R = R1*N
	    
*/
% 2. This exercise examines the importance of tail recursion, in the light of the semantics given in the chapter.
% Consider the following two functions:

fun {Sum1 N}
  if N==0 then 0 else N+{Sum1 N-1} end
end

fun {Sum2 N S}
  if N==0 then S else {Sum2 N-1 N+S} end
end

% (a) Expand the two definitions into kernel syntax. It should be clear that Sum2 is tail recursive and Sum1 is not.

% Program Code
% Base on basic factorial definition
declare Sum1
Sum1 = proc{$ N R}
      local A in
         A=(N == 0)
      if A then R = 0
      else
        local N1 in                %S1
        local R1 in                %S2 
           N1 = ( N - 1)           %S3
           {Sum1 N1 R1}            %S4
           R = (N + R1)            %S5
       end
       end
       end
        end
       end

{Browse {Sum1 3}}

%tail recursion
declare Sum2
Sum2 = proc{$ N S R}
	  local X in
	     X = (N == 0)
	     if X then R = S
	     else local N1 in
		     local S1 in
			N1 = (N - 1)
			S1 = (N + S)
			{Sum2 N1 S1 R}
		     end
		  end
	     end
	  end
       end
{Browse {Sum2 3 0}}

% (b) Execute the two calls {Sum1 3} and {Sum2 3 0} by hand, using the semantics of this chapter to follow what 
%  happens to the stack and the store. 
%  Specifically, for the first iteration through the procedure definition, show the affect of each statement on the
%  stack, environemnt, and store similar to Dr. Wilson's Piazza post @85. Iteration two and three will be similar

%  so only show the environemnt, store, and stack right before the recursive call. Then, for iteration 4 (Base Case)
%  go through each statement, and finish popping statements off of the stack from the previous procedure calls.

/*
Your answer
{Sum1 3} will output 6. The statement {Sum1 = proc{$ N R}} is a value creation statement with a proc value. There are no variables that are free so the closure has an empty environment at first look. A new variable is introduced in the store that is bound to this value say r'. This {s1, 3) is taken out of the stackb/c it's been executed.

The statement (local A in) is a local statement which introduced a new variable and is made in the store and is extended to the environment. The body of the local is (a sequence) pushed into the stack. The statement (A = (N == 0) sees that A is equal to 0 in which N is in equivalence to 0(equivalence check). The statement (if A then R = 0) is an if statement, whenthe condition is looked at, it evaluates to false since N is not 0 but instead 3. This is pushed out of thet stack and the else statement is then instead executed. This else statement contains some nested local statements which creates new vriables and are placed into the store and extends the environment to it. N1 is bound to the result of N (result:3) minus 1 while R1 is the recursive result to be made from N1. The last statement (R = (N + R1)) is the final result from the recursion on N1 and R1 which should output 3, but the recursive statement executed before the last statemetn will push more and more statemetns onto the stacks which consists of interasions of 3-1 & 2-1 to get the sum and will mete the base case which is the statement if A then R = 0. These statemetns will execute in the same fashion (terms of stack, environemnt, and store) as before but with N-1 instead of just N. these will come off the stack and the last statement will be executed giving the output of 3. 

In the tail recursive function of {Sum2 3 0} should give the output of 6. In the statement {Sum2 = proc($ N S R} is a value creation statement with a proc value. There are not any free variables so the closure has an empty environement at first. the local X in statement is a local statement that introduces a new variable thats made in the store with the environment extending to it. The body of the local is pushed into the stack. The statement inside that local statement X=(N==0) sees that X is equal to 0 in which N is an equivalence check to 0. The if statement following that statement is a boolean condition (X) that evaluates to false since N is not 0 but instead the value 3. This is removed from the stack and the else statement follow that if statement is executed. The else statement contains nested local statements which introduces new variables to the store (N1 and R1) and extends it to the environment. N1 is bound to the result of N (3) - 1 while S1 is the result of N (3) plus S which is 0. Because this function uses tail rescursion, the last statement (which is the tail recursion) is done last so the stack will execute the recursive iterations of 3-1, 2-1 and the base case as last. The recursive call has R as the result which is the same as the proc's R result since it is tail recursive. The recursion will return the output 6, the final result.
*/

% (c) What would happen in the Mozart system if you would call {Sum1 100000000} or {Sum2 100000000 0}? Which one 
% is likely to work? Which one is not? Try both on Mozart to verify your reasoning.
/*
Your answer																				   
Sum2, the tail recursive function has a strong possibility of working because of the nature of how the recursion is the last statement hence the name tail recursion. The space of the stack won't become larger and larger since there isn't some other statmenet that needs to be executed within the stack after the recursion has been called as seen in the function Sum1.
*/

% 3. Given the following program code:

/*
fun {Eval E}
  if {IsNumber E} then E 
    else
    case E
    of plus(X Y) then {Eval X}+{Eval Y} 
    [] times(X Y) then {Eval X}*{Eval Y} 
    else raise illFormedExpr(E) end
    end
  end 
end

try
  {Browse {Eval plus(plus(5 5) 10)}} 
  {Browse {Eval times(6 11)}} 
  {Browse {Eval minus(7 10)}}
catch illFormedExpr(E) then
  {Browse  ́*** Illegal expression  ́#E# ́ *** ́}
end
*/

% Include the Records divide(X Y), list(L) which returns the list L, and append(H T) which takes an integer and appends it to a list
% such that the function Eval will return either an integer, a list, or an error.
% Change the catch into a pattern matching catch (Page 96) with the following exceptions
%     illFormedExpr(E)   -- same as the already existsing error
%     illFormedList(E)   -- if list(L) is evaluated and L is not a list (using a helper function IsList that you define)
%                             IsList checks if the head of the input is an integer, then recursively checks the rest of 
%                             the list. Base case is nil which returns true. 
%     illFormedAppend(E) -- if append(H T) is passed to Eval and H is not an integer (using the IsNumber function)

% Include another exception for dividing by 0, such that the exception will then execute the division, by changing the 
% denominator to 1, and output the result to the browser. This exception will not be in the pattern matching catch 
% described above, but will be on the outside (You will need a nested try, catch statement to achieve this)

% Program Code NOTE: DOESNT WORK
fun {Eval E}
  if {IsNumber E} then E 
    else
    case E
    of plus(X Y) then {Eval X}+{Eval Y} 
    [] times(X Y) then {Eval X}{Eval Y}
    [] divide(X Y) then {Eval X}/{Eval Y}
    else raise illFormedExpr(E) end
  if {IsList E} then E|nil
    else
    case E 
    of list(L) then 
    %[] raise illFormedList(E)
    [] append(H T) then
    else raise illFormedAppend(E)end
   end
  end 
end

try
  {Browse {Eval plus(plus(5 5) 10)}} 
  {Browse {Eval times(6 11)}} 
  {Browse {Eval minus(7 10)}}
catch illFormedExpr(E) then
   {Browse  ́** Illegal expression  ́#E# ́  ́}
catch illFormedList(E) then
   if {IsList L}==false then {Browse  Illegal list #E#  }
catch illFormedAppend(E) then
   if {Eval append(H T)}==false andthen {isNumber H} then {Browse  Illegal append #E# *** }
catch divideByZero(E) then
   if Y==0 in {divide(X Y)} then Y = 1
   {Browse {Eval divide(X Y)}}
end

% Describe the process, in terms of the stack, from the moment a division by 0 exception is raised, to the moment the division 
% division is executed with a new denominator. (Ignore Environment and Store)

/*
    Your answer
*/

% 4. Based on the unification algoirthm on page 103, describe the unification process for the following example
%    Describe the Stack, Environment, and Store as each statement is executed, similar to Q2(b), and show the output store
%    Remark: Describe each step in the unification when it occurs, using the syntax unify(X,Y), bind(ESx,ESy), etc.
%            as shown on page 103

declare X Y A B C D E F G H I J K L M N %all these variables are mapped to each other x->y->a...
L = D
M = D
N = F
A = birthday(day:3 month:C year:1986)
B = birthday(day:D month:D year:F)
I = J
J = 19
K = D
X = person(age:I name:"Stan" birthday:A)
Y = person(age:G name:H birthday:B)

/*
Your answer
There is nothing in the stack, store and environement yet until the delcaration happens. Declare X Y A B C... and so forth are added to the store (unbounded variables equal to themselves or equivalence sets of themselves) and the environment includes them instead of being empty. The stack is pushed and popped from this statement.
The statement L = D is pushed onto the stack and popped when finished.
unify(L,D) is done in the store since L = D is unified. bind(ES1,ESd is done to bind their equivalence sets together. The statement M = D is also the same case except D is already binded with (L,D) so it will becomes (L,D,M) through unify(M,D) -> bind(ESm, ESd). This is also pushed and popped from the stack.
The statement N = F are their own sets. This is pushed and popped when finished. unify(N,F) -> BIND (ESn, ESf). The statement A is an equivalence set of itself that's bounded to a record so its a variable thats determined. unify(A<birthday>) -> bind(ESa, <birthday>). For statement B, it's basically the same thing, unify(B,<birthday>) -> bind (ESb, <birthday>), but the day is D which is (D,L,M) and the month is also D which is (D,L,M) and the year will be F which is (F, N). For statement I = J is unify(I,J) -> bind(ESi,ESj), (I,J). The statement that follows that is J = 19 is unify(J,19) -> bind (ESj, 19) that makes I & J equal to the number 19 and those variables become determined since I was boundede to J in the previous statement, (I,J,19). The statement K = D adds K to (L,D,M,K) but since D is used in the record for <birthday> which is already bound to B, it also becomes (L,D,M,B,K). unify(K,D) -> bind(ESk,ESd). Statement X is similiar to the statement A, it is an equivalence set of itself thats bounded to a record, so it's a determined variable. unify(X,<person>) -> bind(ESx, <person>). But since the record <person> also uses I & A, X is added into (I,J,19,A,X). I will be 19, birthday will be set to day 3, month is C, and year 1968 while X may represent the entirety of the records contents. Y is basically the same thing, unify(Y,<person>) -> bind(ESy,<person>). the record <person> uses G for age and H for the na me and B for birthday so Y is added to (G,H,B,D,L,M,K,F,N,Y).

{Browse X} = person(age:19 birthday:birthday(day:3 month:_ year:1986) name:[83 116 97 110])
{Browse Y} = person(age:_ birthday:birthday(day:_ month:_ year:_) name:_)
{Browse A} =_ 
{Browse B} =_
{Browse C} =_
{Browse D} =_
{Browse E} =_
{Browse F} =_
{Browse G} =_
{Browse H} =_
{Browse I} = 19
{Browse J} = 19
{Browse K} =_
{Browse L} =_
{Browse M} =_
{Browse N} =_
*/

