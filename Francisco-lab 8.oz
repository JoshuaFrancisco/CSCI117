%%%% CSci 117, Lab 8 %%%%
%%%% Joshua Francisco %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 


% Part 1: Conceptual

% Q1 Laziness and concurrency
% This exercise looks closer at the concurrent behavior of lazy execution. Execute the following:

fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end
X={MakeX}
Y={MakeY}
Z={MakeZ}
{Browse (X+Y)+Z}

% This displays x and y immediately, z after 6 seconds, and the result 6 after 15 seconds. 
% Explain this behavior. What happens if (X+Y)+Z is replaced by X+(Y+Z) or by thread X+Y end + Z? 

/*
If X+(Y+Z) replaces (X+Y)+Z, then x will display immediately, y and z after 6 seconds, and the result 6 after 15 seconds.
If thread X+Y end + Z replaces (X+Y)+Z, then x+y will display, then +z, and the result 6 after. 
*/   
   
% Which form gives the final result the quickest?

/* The threaded form is the quickest */
   
% How would you program the addition of n integers i1, ..., in, given that integer ij only 
% appears after tj milliseconds, so that the final result appears the quickest?

/*
How I would program the following program for the fastest possible result is that I would implement a lazy function or thread with streams function where adjacent integers are added in parentheses.
*/
				
% Q2 Laziness and monolithic functions. 
% Consider the following two definitions of lazy list reversal:

fun lazy {Reverse1 S} 
  fun {Rev S R}
    case S of nil then R
    [] X|S2 then {Rev S2 X|R} end 
    end
in {Rev S nil} end 

fun lazy {Reverse2 S} 
  fun lazy {Rev S R}
    case S of nil then R
    [] X|S2 then {Rev S2 X|R} end 
  end
in {Rev S nil} end

% What is the difference in behavior between {Reverse1 [a b c]} and {Reverse2 [a b c]}? 

/*
The difference between these two reverses is that in Reverse 2 it includes lazy in fun lazy {Rev S R} whereas lazy is not present for that line in Reverse1.
*/

% Do the two definitions calculate the same result? Do they have the same lazy behavior? Explain your answer in each case. 

/*
These two definitions both will calculate the same result but do not have the same lazy behavior.
*/

% Finally, compare the execution efficiency of the two definitions. Which definition would you use in a lazy program?
% (Generate a very long list e.g. size 10000 and run both reverse fucntions on the two lists, timing with your phone)

/*
The second reverse function definition is more efficient and is the much more  preferred definition for a lazy program.
*/

% Q3 Concurrency and exceptions. 
% Consider the following control abstraction that implements try–finally:

proc {TryFinally S1 S2} 
  B Y in
    try {S1} B=false catch X then B=true Y=X end 
    {S2}
    if B then raise Y end end
end

% Using the abstract machine semantics as a guide, determine the different possible results of the following program:

local U=1 V=2 in 
cc  {TryFinally
   proc {$} 
    thread
      {TryFinally proc {$} U=V end
                  proc {$} {Browse bing} end}
    end 
   end
   proc {$} {Browse bong} end} 
end

% How many different results are possible? 

% How many different executions are possible?


% Part 2: A new way to write streams

% Q1 Programmed triggers using higher-order programming. Programmed triggers can be implemented by using higher-order programming 
% instead of concurrency and dataflow variables. The producer passes a zero-argument function F to the consumer. 
% Whenever the consumer needs an element, it calls the function. This returns a pair X#F2 where X is the next stream element 
% and F2 is a function that has the same behavior as F. 
% A key concept for this question is how to return 0 argument functions. For example, the functin that returns the value 3
% can be written as   F = fun {$} 3 end   such that {F} will return the value 3. 

% (a) write a generator for the numbers 0 1 2 3 ..., where the generator returns a pair V#F, V being the next value in the 
% stream and F being the function that returns the next V1#F1 pair. 
% exmaple with generator G1...    {G1} -> 0#G2      {G2} -> 1#G3     {G3} -> 2#G4
declare
fun lazy {Generate N}
    N#{Generate N+1}
end
L = {Generate 0}
M = {Generate 10}

% (b) write a function that displays the first N values from the stream in part a
fun {Display L N}
    if N > 0 then L.1|{Display L.2 N-1} else nil end
end
{Browse {Display L 4}}

% (c) write a function that takes the stream from a as input, and returns a stream with the numbers multiplied by some number N
%     e.g. N = 3 ... the stream would be 0 3 6 9 ...
fun lazy {Mul L N}
    (L.1*N)|{Mul L.2 N}
end
{Browse {Display {Mul L 3} 4}}

% (d) write a function that takes a stream as input, and adds the number N to the front of the stream.
%  e.g. the stream 1 2 3 4 ... with N = 5 would return 5 1 2 3 4 ...
fun {Insert L N}
   N#L
end
{Browse {Display {Insert L 10} 3}}

% (e) write a function that merges two streams into a single stream, where the output is the zip of the two streams
%    e.g.   S1 = 1 2 3 4 ...   S2 = a b c d ..    output = 1 a 2 b 3 c ...
fun lazy {Merge L M}
   L.1|M.1#{Merge L.2 M.2}
end
{Browse {Display {Merge L M} 8}}



% Q2 Hamming Problem
% Convert the solution of the hamming problem for primes 2,3,5 given in the book section 4.5.6 from an implementation using 
% lazy generators, to an implementation using the generators described in part two that produce value function pairs. 
% Note that you will still be needing data flow variables.
% Hint  -> Merge will take in generators, and return a generator (function that returns a value function pair)
% Hint  -> H will be a generator, where the first call {H} will return the pair 1#(some function)






