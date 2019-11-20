%%%% CSci 117, Lab 3 %%%%
%%%% Joshua Francisco %%%%

% 1. If a function body has an 'if' statement with a missing 'else' clause, then an exception
%    is raised if the 'if' condition is false. Explain why this behavior is correct. This 
%    situation does not occur for procedures. Explain why not.
/*
Your answer:
This behavior is correct because the "if" statement checks if the statement is true or not based upon the condition defined. An exception is raised if the condition is false because
there is no "else" statement and does not know what to do if it is false. For procedure, this type of behavior is different because as with proc, it does not have to neccesarily returna value
*/

% 2. Using the following:
%    (1) - if X then S1 else S2 end
%    (2) - case X of Lab(F1: X1 ... Fn: Xn) then S1 else S2 end
% (a) Define (1) in terms of the 'case' statement. 

% Your answer:
% (a) case X of Lab(F1:X1 ... Fn:Xn) then S1 else S2 end

% (b) Define (2) in terms of the 'if' statement, using the operations
%     Label, Arity, and '.' (feature selection). 
%     Note - Don't forget to make assignment before S1. You should use ... when ranging from F1 to Fn.

% Your answer:

local X = lab(F1: X1 ... Fn: Xn) in
   {Label X}=lab
   {Arity X}=X.F1
   ...
   {Arity X}=X.Fn
    if X then S1
    else S2
 end
end


% (c) Rewrite the following 'case' statement using 'if' statements

declare L
L = lab(f1:5 f2:7 f3:'jim')
case L of lab(f1:X f2:Y f3:Z) then
   case L.f1 of 5 then {Browse Y}
   else
      {Browse a}
   end
   else
   {Browse b}
end

/*
example of pattern matching
Tree = tree(right:5 left:3)
case T of tree(right: X1 left: X2)
   local X1 X2 in
      X1 = T.right
      X2 = T.left
*/

% Program Code
declare L
L = lab(f1:5 f2:7 f3:'jim')

fun lab(f1:X f2:Y f3:Z)
   if L.f1==f1.5 then
           {Browse Y}
      else {Browse a}
   end
      else {Browse b}
end

% 3. Given the following procedure:

declare
proc {Test X} 
  case X
  of a|Z then {Browse  'case (1)'}
  [] f(a) then {Browse  'case (2)'}
  [] Y|Z andthen Y==Z then {Browse  'case (3)'} 
  [] Y|Z then {Browse  'case (4)'}
  [] f(Y) then {Browse  'case (5)'}
  else {Browse  'case (6)'} end
end

% Without executing any code, predict what will happen when you feed
% {Test [b c a]},
% {Test f(b(3))},
% {Test f(a)},
% {Test f(a(3))},
% {Test f(d)},
% {Test [a b c]},
% {Test [c a b]},
% {Test a|a}, and
% {Test  ́| ́(a b c)}

% Run the code to verify your predictions.

/*
Your answer
{Test [b c a]}, will output the  "case (4)" At case 4's line [b c a] matches that of Y|Z.
{Test f(b(3))}, will output the "case (5)" At case 5's line [f(b(3)] will also match f(Y).
{Test f(a)}, will output the "case (2)" At case 2's line f(a) matches that of f(a).
{Test f(a(3))}, will output the "case (5)" At case 5's line, f(a(3)) has an exact match of f(b(3)).
{Test f(d)}, will output the the  "case (5)" At case 5's line, f(d) matches that of f(b(3)).
{Test [a b c]}, will output the "case (1)" At case 1's line,  [a b c] matches that of a|Z.
{Test [c a b]}, will output the "case (4)" At case 4's line, [c a b] will match that of Y|Z
{Test a|a}, will output the "case(1)" At case 1's line, a|a will match that of a|Z.
{Test  ́| ́(a b c) will output "case(6)" After checking through cases 1-5, operation will find no other match and will conclude that '|' (a b c) is case 6.
*/

% 4. Given the following procedure:

declare
proc {Test X}
  case X of f(a Y c) then {Browse 'case (1)'} 
  else {Browse  'case (2)'} end
end

% (a) Without executing any code, predict what will happen when you feed
% declare X Y {Test f(X b Y)}
% declare X Y {Test f(a Y d)}
% declare X Y {Test f(X Y d)}

% Run the code to verify your predictions.
/*
Your answer:
declare X Y {test f(X b Y)} would execute {Browse case(2)}, that is because of  f(X b Y) which  does not match the case of f(a Y c). declare X Y {Test f(a Y d)} would execute {Browse 'case (1)'} because f(a Y d) matches f(a Y c).
declare X Y {Test f(X Y d)} would execute output condition {Browse 'case(2)'} because f(X Y d) does not matcht that of f(a Y c). The capital letters X Y are identifiers and must match explicitly, while the lowercase letters a b d are atoms and more open in their matching.
*/

% (b) Run the following example:

declare X Y
if f(X Y d)==f(a Y c) then {Browse 'case (1)'} 
else {Browse 'case (2)'} end

% Is the result different from the previous example? Explain.
% Run the code to verify your predictions.

/*
Your answer
While using the if statement code instead of using the case statement code, testing the third line for X Y d, where f(X Y d) == f(a Y C), will output the case 'case(2)', this is because if statements and case statements practically work the same way in that they check a bool condition, and if the condition is true, then it will execute the following code, X b Y and a Y d will also output 'case(2)' because they do not meet the condition of being f(X Y d) although f(a Y d) doesn't match f(a Y c).

*/

% 5. Given the following code:

declare Max3 Max5
  proc {SpecialMax Value ?SMax}
    fun {SMax X}
      if X>Value then X else Value end
  end 
end
{SpecialMax 3 Max3} 
{SpecialMax 5 Max5}

% Without executing any code, predict what will happen when you feed
% {Browse [{Max3 4} {Max5 4}]}
% Run the code to verify your predictions.
/*
Your answer
{Browse [{Max 3 4} {Max 5 4]}} will give the outputs 4 and 5, This procedure and function output the maximumm of two values by storing and comparing the values between each other.
*/


% 6. Expand the following function SMerge into the kernel syntax.
% Note - X#Y is a tuple of two arguments that can be written '#'(X Y). 
%        The resulting procedure should be tail recursive if the rules from
%        section 2.5.2 are followed correctly.

declare
fun {SMerge Xs Ys} 
  case Xs#Ys
  of nil#Ys then Ys
  [] Xs#nil then Xs
  [] (X|Xr)#(Y|Yr) then
    if X=<Y then 
      X|{SMerge Xr Ys}
    else
      Y|{SMerge Xs Yr}
    end 
  end
end

% e.g.
{Browse {SMerge [1 2 3] [1 2 3]}}

% Program Code



