%%%% CSci 117, Lab 6 %%%%
%%%% Joshua Francisco %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 


% Part 1: Control Flow

% For each question, come up with three operations, and test these operations on lists, displaying the input and output in a comment. 
/*
Q1 Binary Fold
The function BFold L F takes a list of integers L and a binary operation on integers F, and returns the binary fold of the F applied to L, where the binary fold is defined as follows:
• BFold where L contains a single element returns that element
• BFold where L contains two or more elements returns BFold of Bmap L F
  • Bmap applies F to successive pairs of a list as follows:
    • Bmap of a list with two or more elements, e.g. X|Y|Ls returns {F X Y} | {Bmap Ls F}
    • Bmap of a list with a single or no element, returns the list, i.e. Bmap [X] F returns [X] and Bmap nil F returns nil
*/

declare L M N P
L = [1 2 3 4]
M = [1 2 3 4 5]
F = 0#'+'

fun {Bmap F Xs}
   if Xs == nil then nil else
   if Xs.2 == nil then Xs.1 else
   local
      X = Xs.1
      Y = Xs.2.1
      Ys = Xs.2.2
   in
   case F.2 of '+' then (X + Y + F.1) | if {IsList Ys} then {Bmap F Ys} else {Bmap F [Ys]} end
   [] '*' then (X * Y * F.1) | if {IsList Ys} then {Bmap F Ys} else {Bmap F [Ys]} end
   [] '-' then (X - Y - F.1) | if {IsList Ys} then {Bmap F Ys} else {Bmap F [Ys]} end
   [] '/' then ((X div Y) div F.1) | if {IsList Ys} then {Bmap F Ys} else {Bmap F [Ys]} end
   end
   end
   end
   end
end

fun {BFold Xs F}
   case Xs of nil then nil
   [] X|Xr andthen Xr == nil then X
   [] X|Y|Xr then {BFold {Bmap F Xs} F}
   [] X|Y then {Bmap F [X Y]}
   end 
end

{Browse {BFold L F}}			   
   
/*
Q2 Nested Fold
The function NFoldL L FZs takes a nested list L and a list of binary operators, value pairs. If FZs is ordered as   [ F1#ZF1 F2#ZF2 F3#ZF3 ... ], you will use the function Fi at the nested depth i, performing the right associative fold operation, with the second value of each pair being the initial value of the folds. 
e.g.)
{ NFold [ 1 2 [2 3] [1 [2 3] ] ] [ F#ZF G#ZG H#ZH ] }
F 1 (F 2 (F (G 2 (G 3 ZG)) (F (G 1 (G (H 2 (H 3 ZH)) ZG)) ZF)))

You will raise an error if the nesting depth d is greater than the length of FZs (i.e. There are not enough functions in FZs to match each level of nesting in L)
*/

declare L Q
L =  [ 1 2 [2 3] [1 [2 3] ] ]
Q = ['F'#'ZF' 'G'#'ZG' 'H'#'ZH']
%{Browse {List.length Q}}

fun {Nmap F Xs}
   if F == nil then 'Error' else %%% FIXME
   local
      Y = F.1.1
   in  
   case Xs of nil then F.1.2
   [] X|Xr andthen {IsList X} then Y|{Nmap F.2 X}|{Nmap F Xr}
   [] X|Xr andthen Xr == nil then Y|X|F.1.2
   [] X|Xr then Y|X|{Nmap F Xr}
   end
   end
   end
end

fun {NFold Xs F}
   case Xs of nil then nil
   [] X|Xr andthen Xr == nil then X
   [] X|Y|Xr then {Nmap F Xs}
   end 
end

{Browse {NFold L Q}}

/*
Q3 Scan
The function ScanL L Z F takes a list L, Initial value Z, and a binary function F. This will return a list with successive left folds. With L = [X1 X2 X3 X4 …] we will get the list
[ Z, F Z X1, F ( F Z X1) X2, ….] where the last element of the output is exactly the FoldL of L Z F. 
*/

declare
M = [1 2 3 4]
N = 0
G = '+'

fun {FoldL L Z F}
   if L == nil then nil else
   if L.1 == nil andthen L.2 \= nil then Z|{FoldL L.2 Z F} else
   local
      X = L.1
      Y
      Ys = L.2
   in
   case F of '+' then Y = (X + Z) Y|{FoldL Ys Y F}
   [] '*' then  Y = (X * Z) Y|{FoldL Ys Y F}
   [] '-' then  Y = (X - Z) Y|{FoldL Ys Y F}
   [] '/' then  Y = (X div Z) Y|{FoldL Ys Y F}
   end
   end
   end
   end
end

fun {ScanL L Z F}
   case L of nil then nil
   [] X|Xr andthen Xr == nil then X
   [] X|Xr then {FoldL nil|L Z F}
   end 
end

{Browse {ScanL M N G}}

% Part 2: Secure Data Types

/*
Secure Dictionary
Implement the list-based declarative dictionary as an ADT, as in Figure 3.27 on p. 199, but in a secure way, using wrap and unwrap, as outlined in Section 3.7.6 (Page 210). Each dictionary will come with two extra features, a binary function F on integers and an integer Z. Your dictionary will have integers as keys (aka features) and pairs of integer lists and atoms as values. The key for each list-atom pair will be calculated from the list by performing a left-associative fold on the list using F and Z. As a result, the Put function will not take a Key as argument but calculate it from the Value. Make sure the code for Put is updated appropriately.

After creating your dictionary, run several Put, CondGet, and Domain examples, displaying the inputs and outputs in a comment. Answer the following questions:
a) What happens when two distinct lists have the same Key value after the folding operation, based on the definition of Put from the book? Give an example.
b) Describe the NewWrapper function on page 207. How does the wrapper/unwrapper created by this function secure the dictionary?
c) Are the F and Z values associated with the dictionary secure? If not, how could you make these secure as well?
*/
 /*

a.)
b) The dictionary is secured by the wrapper/unwrapper because the only way to unwrap a wrapped value is by using the only appropriate unwrap operation.

c) The F and Z values are unsecure. They can be secured by making wrapper/unwrapper functions for those values.

*/


% Part 3: Declarative Concurrency

/*
Given the following program code:
local A B C in 
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% A %thread creates a new stack 
    A = 5  %%%%%%%%%%%%%%%%%%%%%%%%%% T1
  end
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% B %thread creates a new stack
    B = 7  %%%%%%%%%%%%%%%%%%%%%%%%%% T2
  end
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% C %thread creates a new stack, creating new stacks look at possibilies of execution statements.`
    C = 3  %%%%%%%%%%%%%%%%%%%%%%%%%% T3
  end
  if C > A then  %%%%%%%%%%%%%%%%%%%% S1
    {Browse “C is greater than A”} %% S2
  else
    if B > A then  %%%%%%%%%%%%%%%%%% S3
      {Browse “B is greater than A”}% S4
    end
  end
end
What are all the possible interleavings of the statements A, B, C, T1, T2, T3, S1..S4? How about when A = 2?
[["A","B","C","T1","T2","T3","S1","S3","S4"],
 ["A","T1","B","C","T2","T3","S1","S3","S4"],
 ["A","B","T1","C","T2","T3","S1","S3","S4"],
 ["A","B","T2","C","T1","T3","S1","S3","S4"],
 ["A","B","C","T2","T1","T3","S1","S3","S4"],
 ["A","T1","B","T2","C","T3","S1","S3","S4"],
 ["A","B","T2","T1","C","T3","S1","S3","S4"],
 ["A","B","T1","T2","C","T3","S1","S3","S4"],
 ["A","B","C","T3","T1","T2","S1","S3","S4"],
 ["A","B","C","T1","T3","T2","S1","S3","S4"],
 ["A","T1","B","C","T3","T2","S1","S3","S4"],
 ["A","B","T1","C","T3","T2","S1","S3","S4"],
 ["A","B","T2","C","T3","T1","S1","S3","S4"],
 ["A","B","C","T3","T2","T1","S1","S3","S4"],
 ["A","B","C","T2","T3","T1","S1","S3","S4"],
 ["A","B","C","T3","T1","S1","T2","S3","S4"],
 ["A","B","C","T1","T3","S1","T2","S3","S4"],
 ["A","B","T1","C","T3","S1","T2","S3","S4"],
 ["A","T1","B","C","T3","S1","T2","S3","S4"]]
When A = 2:
[["A","B","C","T1","T2","T3","S1","S2","S3"],
 ["A","T1","B","C","T2","T3","S1","S2","S3"],
 ["A","B","T1","C","T2","T3","S1","S2","S3"],
 ["A","B","T2","C","T1","T3","S1","S2","S3"],
 ["A","B","C","T2","T1","T3","S1","S2","S3"],
 ["A","T1","B","T2","C","T3","S1","S2","S3"],
 ["A","B","T2","T1","C","T3","S1","S2","S3"],
 ["A","B","T1","T2","C","T3","S1","S2","S3"],
 ["A","B","C","T3","T1","T2","S1","S2","S3"],
 ["A","B","C","T1","T3","T2","S1","S2","S3"],
 ["A","T1","B","C","T3","T2","S1","S2","S3"],
 ["A","B","T1","C","T3","T2","S1","S2","S3"],
 ["A","B","T2","C","T3","T1","S1","S2","S3"],
 ["A","B","C","T3","T2","T1","S1","S2","S3"],
 ["A","B","C","T2","T3","T1","S1","S2","S3"],
 ["A","B","C","T3","T1","S1","T2","S2","S3"],
 ["A","B","C","T1","T3","S1","T2","S2","S3"],
 ["A","B","T1","C","T3","S1","T2","S2","S3"],
 ["A","T1","B","C","T3","S1","T2","S2","S3"],
 ["A","B","C","T3","T1","S1","S2","T2","S3"],
 ["A","B","C","T1","T3","S1","S2","T2","S3"],
 ["A","B","T1","C","T3","S1","S2","T2","S3"],
 ["A","T1","B","C","T3","S1","S2","T2","S3"]]