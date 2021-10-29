<!-- mdtocstart -->

# Table of Contents

- [Structure and Interpretation of Computer Programs](#structure-and-interpretation-of-computer-programs)
    - [Framework for analysing languages](#framework-for-analysing-languages)
    - [Tackling complexity](#tackling-complexity)
    - [Iteration VS Linear recursion](#iteration-vs-linear-recursion)
    - [Operator overloading and the glory of prefixed operations](#operator-overloading-and-the-glory-of-prefixed-operations)
    - [Naming Spirits](#naming-spirits)
    - [Generic Operators](#generic-operators)
    - [Assignment, State, and Side-effects](#assignment-state-and-sideeffects)
    - [Streaming](#streaming)
        - [Time and Ordering](#time-and-ordering)
    - [Cool Quick Stuff](#cool-quick-stuff)

<!-- mdtocend -->

# Structure and Interpretation of Computer Programs

All the notes and code I have written during the [SICP course](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/)

## Framework for analysing languages

* Primitives
* Composition
* Abstraction

LISP examples:

* Primitive: 1
* Composition: (+ 1 4 (- 2 3))
* Abstraction: (define (myfunc x) (* xx))

All languages are formed by these three, always analyse a
language through these lenses if you aim at assessing it by
its own expressiveness (not support/ecosystem/etc).

## Tackling complexity

There is 3 main ways to handle complexity:

* Black box abstraction
* Conventional (uniform) interfaces
* Making new languages (metalinguistic abstraction)

When discussing software engineering there is a great
deal of focus on black box abstraction. There is
less discussion on the greatness of finding good
uniform interfaces (like plan9 representing all
resources uniformly through a file interface).

There is even less discussion on building languages =(.

## Iteration VS Linear recursion

Giving some cool examples, it is presented the idea of iteration and linear recursion.
It does not have anything to do with using recursive functions on the language, it is
the nature of the algorithm.

Even using recursion, if the nature is iterative you will have a fixed O(1) space
complexity. If the nature is recursive, space complexity will be N.

It seems to me that the iteration version is what is optimized to tail recursion, so even
if you have a recursion, the space complexity is O(1). Linear recursion would be when
you cant tail optimize and the space complexity linearly (or worse) grows.

Iterative add:

```
(define (add x y) 
    (if (= x 0) (y) (add (-1+ x) (1+ y))))
```

Linear recursive add:

```
(define (add x y) 
    (if (= x 0) (y) (1+ (add (-1+ x) (y))))
```

Both are recursive definitions, but just one is a recursive procedure.
When you evaluate the linear recursive one, it will expand as big as X.
The iterative one has always the same size.

Iterative add:

```
(add 3 4)
(add 2 5)
(add 1 6)
(add 0 7)
7
```

Recursive add:

```
(add 3 4)
(1+ (add 2 4))
(1+ (1+ (add 1 4)))
(1+ (1+ (1+ (add 0 4))))
(1+ (1+ (1+ 4)))
(1+ (1+ 5))
(1+ 6)
7
```

## Operator overloading and the glory of prefixed operations

It seems that operator overloading is a good idea because of uniformity.
For native types like integers you can write:

```
1 + 2 + 3 + 4
```

But if I have a complex type (like complex numbers) and want to add them I would need to:

```
complex1.add(complex2).add(complex3).add(complex4)
```

Well, that is one way to do that, but without operator overloading you cant escape from
losing uniformity on your code. Operator overloading allows you to:

```
complex1 + complex2 + complex3 + complex4
```

But on a prefixed (and already uniform) language like lisp you have:

```
+ 1 2 3 4
```

It is already cool because you dont have to repeat the operator. But now if you want to
add complex you can just define a new function (the operator is also just a function on lisp):

```
add complex1 complex2 complex3 complex4
```

Its a interesting win for prefixed operations. Symmetry is beautiful.

## Naming Spirits

Since the course has a lot of metaphors with programming being like magic,
where you write magical spells and command them to be executed, giving life
to things, it is expected that more metaphors related to magic would appear.

A great one is the idea of give names to spirits. It is common knowledge
that if you know a spirit name you have control over it. Missing concepts on
the code (usually abstractions, like functions or data structures) are like spirits
spread through your code, you have no power over them. Extracting them and giving
them a name gives you control over them.

It is a nice metaphor to extract functions and create abstractions that helps
to solve more than one problem.

For example, when implementing the heron's method to calculate square roots
if we do not identify the fixed point spirit by name and extract it
as a separated function from the square root calculation we would be
unable to use it on other functions that also needs a fixed point.

Besides reuse of code, we would have a hard time identifying that
the heron's method uses fixed point to find the solution, it would be
implicit. So even when reuse is not in play, extracting these spirits
from code and naming them can make things more clear.

What is interesting is that you can't escape the spirit, if you do
not name it, it will still be there, but nameless, uncontrolled, rampaging
through your code.

## Generic Operators

On lecture [4B](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/4b-generic-operators/) Hal Abelson brilliantly presents a very simple problem (representing complex numbers) and how
to add generic operators (like add and mul) that works transparently independent from how the
complex numbers are implemented (using polar values of the real/imaginary one). The problem is extended
to even operating on polynomials.

At the start of the problem he shows generic operators that basically does some ifs
and operates differently depending on the type of the complex number. He shows that
this design is not a good one because it does not accomodate change well, since everytime
you want to add some new representation of a complex number on the system you need to change
some central code that does some if'ing to check the type (he compares it with some manager
that only does bookeeping =P).

To solve that he introduces the notion of a type system registry. Basically when you
add a new type you also use functions like this:

```
(put 'typename 'functionname functionimplementation)
```

And the generic algorithm are going to get the type of the instance and use it
to find a proper implementation of a function it needs...if that type has a function
registered to it.

He mentions that you could bypass this central type registry completely if each instance
had this map of functions with it, he calls it "messaging". It seems to me that this is
what they understood as object orientation at the time.

The idea seems very appealing to me because it does not require any kind of central type
registry where all types of your program are registered, and it also makes the type of
objects (data structures, or whatever you are passing around on your system) completely
irrelevant. You can just send a message or even query if a message is supported at runtime.

The disadvantage seems to be performance, specially because there will be a LOT of copies of
functions depending on the system you are implementing. When I thought of that I remembered that
copying is the mechanism that life itself uses to solve this, each cell is independent and has
a complete copy of all the functions it can perform, there is no prototype or central type
where the functions are stored.

It seems that nature chose this way and it solved the space problem
with DNA that is simply brilliant on how it stores information. Perhaps we are stuck with bad
models for lack of better ways to support duplication (how we represent information),
or just lack of hardware or nature is wrong =P. Although it is undeniable that life scales
on order of magnitudes that we can't even
compreehend and we are not even close on building something that scales even near as good.


## Assignment, State, and Side-effects

On lecture [5A](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/5a-assignment-state-and-side-effects/) Gerald Jay Sussman introduces the **set!** function, that allows
changing the value associated with a variable. Basically he introduces the concept of
assigment, effectively changing state. Being able to assign new values to the same variable +
scoping (closures) create the same state manipulation mechanism on todays object oriented
languages, with the same perils.

The lecture has a great explanation of the perils of side effects, the lost of the "functionallity" of
the procedures, like:

```
(rand)
(rand)
```

Not producing the same result, hence not being functions anymore.
But the best part is that he presents a very interesting problem, aproximating pi.
The algorithm involves a mounte carlo simulation, that uses randomic numbers.

He shows an implementation where there are side effects on funcions (not purely functional) and
one without side effects. The one with side effects was able to encapsulate the random number
generation inside one place, the mounte carlo algorithm was not even aware that there where
randomic numbers envolved on the experiment (mounte carlo here is used to create a statistical
sampling on top of an experiment).

The functional approach without side effects require the seed of the random number generation to
be retro feed on the random function, since the function is pure and don't keep any state. This
generated the need to expose this parameter on all the APIs, including the mounte carlo one, since
it was called on a loop the loop also need to feed the new parameter for the random number generation.

So in the end the detail of random number generation leaked through all the code, when with state manipulation
we where able to hide it. In the end he is still on doubt if assignments and state manipulation is worth the
trouble...but it is refreshing to see a intelligent perspective (balancing tradeoffs) on the subject
instead of the current hypes.

## Streaming

Streams are presented as a way to construct infinite sets of values using constant space.
The base of a stream seems to me to be lazy evaluation. The implementation of stream presented
is basically one value and a function that will be evaluated later to calculate the rest of
the data. This reminds of features like Python generators or Lua co-routines. But on lisp this is
implemented on a much simpler way and with no syntactic support.

Actually the great lesson is that lazy evaluation is really easy to implement in lisp and so is
streams, as a side effect of that. Although all the manual labor of lazy evaluating things rises
the question of why not always lazy evaluate everything ? Directly on the language ?

On the course this is called [normal order](https://en.wikipedia.org/wiki/Evaluation_strategy#Normal_order)
evaluation, which reminds me a lot of lazy evaluation. What I'm used to (C/Go/Scheme) is called
[applicative order](https://en.wikipedia.org/wiki/Evaluation_strategy#Applicative_order).

In an applicative order lisp, this code:

```lisp
(somefunc 5 (otherfunc 3))
```

Would eval `(otherfunc 3)` first and them pass the result to **somefunc**. On a normal order language
`(otherfunc 3)` would be evaluated only when **somefunc** explicitly uses the value. If **somefunc** does not
use it, or if it juts passes it as a parameter to other function it is not evaluated.

If you think in a call graph the expression is evaluated only at the leaf, when the value is used, when it is
just passed around it keeps not evaluated. The cool thing is that this is transparent to the programmer,
so the code looks the same and runs the same, the only difference is that you get lazy evaluation for
free (something that must be coded manually on an applicative order language).

Well, what is the downside ? On the course (1986) it is mentioned that a lot of languages are exploring this
idea and they can be used for a lot of things, but operational systems cant be developed with them (at least at
the time) because of the "dragging tail problem". What would be this problem ? Basically you cant implement
iterative algorithms on a normal order language, since arguments are always evaluated only when used the
call graph must be maintained until the argument is evaluated, generating a huge tail. It is the opposite of
what tail call elimination does when you use recursion, with normal order it is impossible to do tail
call elimination since by definition you need to maintain the tail until it is lazily evaluated. At the time
this was a research topic and I don't understand this enough to know if this is still a limitation of
normal order languages or if there is already some way to circumvent this downside.

Anyway the streams part of the course gave me a great deal of insight on how lazy evaluation works, and
how to do it manually in a applicative order language.

On this part of the course some of the downsides of object orientation are discussed against streaming and
functional programming styles. It is interesting that at the time this was a hot topic and a lot of research
was being done, and on the course this is presented as a open question and some tradeoffs are discussed
about maintaining state and side effects versus purely functional. Although usually purely functional
algorithms are easier to debug and understand, some problems are harder to express like that (the example
given on the course is a banking system). On the example both streaming programming and functional programming
lacks the features required to handle the problem properly, which is two different clients manipulating the
same joint bank account. One of the open problems mentioned is how to isolate this side effect/state part
of the problem from the rest of the program which is functional, AFAIK this is solved on Haskell with
[Monads](https://wiki.haskell.org/Monad) for example.

Right now I still lack competence to compare functional and object oriented approaches, specially since
I'm not very used to purely functional languages. It is pretty obvious that every time you have something
purely functional, where the substitution model can be applied to your lisp code, debugging and understanding
will be simpler, but there is too much nuances because of different problems that only hands on experience
can provide the proper insights.

But one idea presented on the course made the comparison more interesting, and I was able to understand better
with the help of Tiago Natel. When functional programming is compared with object orientation, Alberson starts
to talk about how in functional programming you don't depend on time, there is no time, which was pretty hard to
me to understand at the time. But an easy way to see it is the lisp substitution model, if you don't have any
side effect with the **set!** function you can apply the substitution model to your code, without any sort of
environment, and you will have the code expanded...ready to be evaluated on just a single step, time is not a factor.

If you need some I/O, time will be a factor. The moment that you perform the I/O in time will
change the result, and it is not just order of the operations on your code, it is literally time, because I/O
usually is a door to resources that are shared across different processes and machines.

This time/sharing component sometimes is intrinsic to the problem that you are solving. The example
given on the course is a banking system with a joint account. You have different independent people/process
that will interact with the account, but when one person manipulates the account YOU WANT the other one
to see the changes, you need side effect, the problem expresses it on itself. Besides watching the side effect
any operation has a tight coupling with time, if one person takes 100 dollars from the account and the other
takes 1000 dollars and the account has exactly 1000 dollars just one of the operations will work and what
will decide which one is time...the order of the operation.

Resuming, the idea is that functional programming allow you to program outside time, like it does not
exist, like you are on a different universe (a different representation of it at least). But if your problem requires
time and ordering to be solved correctly you will not be able to solve it with a purely functional code.
It is good to remember that a some problems are decoupled from time and we find ways to couple them
with time with bad coding =(, so functional programming is a nice idea...but not a new one and not without its
own tradeoffs.

In the end the more interesting idea presented is that these are tradeoffs, there is no brainless glorification
of one idea as the best way to solve all the problems, it seems that today we still stand on the same
point and considering the tradeoffs and working with both techniques seems necessary instead of
just choosing one of them as the promissed messiah to solve all our problems.

For decades the debate of object orientation VS functional programming basically stalled exactly
because the industry assumed that object orientation was fitted to all problems. Now it seems that
we are walking towards making the same mistake, but with functional programming =/.

### Time and Ordering

This is a subject that needs to be expanded on its own since it is pretty hard to me
to understand and it seems pretty fundamental. What is the difference between time
and ordering ? At first it seems like the order of operations matter, even on
mathematical thinking, but with further thought it seems that it is because I'm
used to thinking on a different way, when you have a function you don't alter the
order of things, you can just alter the function itself. For example, lets say we have
an addition and a subtraction operations, like this:

```
(+ z (- x y))
```

It is very clear that the execution has an order, no matter if it is lazy evaluated or not.
But when I try to think on changing the order of the operations, it makes no sense at all,
because trying to change the "order" is the action of literally changing the function and its
meaning, you cant "just" change order of things when you are coding like this. Try to change the
order of even the simplest code like the one above, what would be to change the order ? add first ?
add with what ? Perhaps this ?

```
(- z (+ x y))
```

But it seems that we actually defined a different function, it is not just a reordering
of operations. Each function states the order that operations are going to be applied, but
each of them represent different functions, they are not like the same function just with
a different order, this makes no sense actually.

The confusion comes from the fact that when the code is evaluated it will be done
so in a order, and that order is important to get the right result, but this is a property of a correctly
implemented evaluator, it is even hard to understand how it could not be done so, if it does not evaluate
on order, what will be the value that will be added with "z" ? The order of operations is coupled
in the function definition, it makes no sense to think about it changing the order without thinking
on directly changing the code and its meaning. In this sense the code is completely decoupled
from time since it will have no say on the order that anything will be executed, this order is
defined entirely by the static structure of the code, the definition of the functions.

So the order of the operations are embedded on the code itself, the function definition, just
as in mathematics, how is time modeled and introduced on computing ? At first when I was discussing
this with some friends it seemed that it would have to be something related to concurrency, because
you have the exact same code running but something would go differently (like a non-determinism),
but that was annoying me because at the same time it made sense I remembered that on the course
there is no parallelism/threading or even concurrency and yet the examples of non-functional code
where there. In the end concurrency is a subset of the things that introduce coupling to time.

What seems to introduce coupling to time is the interaction with external agents and the requirement
of having some sort of memory of previous interactions. If you stop to think about it, one way to
see this is to think about ourselves, we are always interacting with each other and we have
memory of previous interactions, how to model that with pure mathematics ? I have a feeling that
this is related to what Alan Kay means when he says that traditional mathematics is not enough
to represent computation, construction of systems, etc. Not that it is not useful, but it has
to be extended, we can't think only on pure traditional mathematics for every computational system.
But this is extremely far ahead of what I can understand today.

One of the most naive examples on the requirement of memory of previous interactions is the bank
system mentioned on the course. So lets use it as an example. Lets say we have a bank account
**x** and a user **y**. The account start with the value 0 and there will be a deposit and a withdraw.
I won't introduce the requirement of memory yet and
I will use define on the code to make it clear that once defined the variable can't have its value changed.

For two operations the possibilities are:

```
(withdraw (deposit 0 100) 100)
```

Which results on success, and a account balance of 0 and:

```
(deposit (withdraw 0 100) 100)
```

Which results on an error since withdraw cant return a negative number.
On both cases the order is part of what makes the code, it is statically defined on it,
and obviously it won't scale when the number of operations grows bigger. If you squint it
is the same thing as with the first example with addition and subtraction, they are actually
two different function definitions, it is not the same thing but with different orders.

What is interesting now is to question ourselves, from both possibilities, what is the
correct one ? Who decides that ? Since this is decided by an external agent (a constraint
imposed by the requirements) you can't code this previously, the order of operations
is defined dynamically, in runtime, by something outside your program.

You could for example make something that awaits
this external stimuli and generates the code accordingly. In lisp it would be
fairly simple to do that actually. But the thing is, it is that dependency on a external
stimuli that introduces that notion of time, because usually this represent some interaction
that comes from the real world, and those interactions will be bound to time and form
the order of the operations. If I do x now and y tomorrow, the order will be x->y because
of the moment in time that I choose to perform the operations. As I choose different
operations the generated code changes to conform to that.

If you continue to push toward something purely functional the code generation idea
seems to be a way to do that. We can design an extremely simple model where all
generated operations are kept (memory) and we always re-evaluate them if you want to
know the current state of your account. Something like:

```
(deposit 100)
(withdraw 10)
```

Which could be passed to a macro to generate this:

```
(withdraw 
  (deposit 0 100) 10)
```

To solve the banking system problem you can't escape the need for memory, this list of events
would have to be stored, and if the system is distributed then the list would have to be distributed with
the system too. But once the list is loaded in memory, the entire processing is completely
functional in a mathematical sense, the final code generated will always grant the
same result when evaluated, time/order has been used to generate the code, but once generated the code
is completely decoupled from time.

Well, that sounds awesome but it has a pretty clear drawback, you have to remember and reprocess
every single operation that happened in your entire life to calculate the state of your account.
This is not how our memory works, we remember a lot of things, but not everything, and we have
a lot of pre-calculated states in our heads, because nature is pretty good with optimizations
(resources in nature are not infinite), so it is tempting to mimic that and come up with a
different computational model, one that resembles more how we work, where you can sometimes remember
all the operations, sometimes just remember a single value and forget everything else (people
usually know how much money they have, but not all the operations that took to get to that state).

I think it is from this that comes the intuition that you can have a piece of "memory" that
every time you do an operation you just update that piece of memory. Like if I have 1000 dollars
on my account, I know that, if I withdraw 100 I will know that now I have 900 dollars. In time
I will only remember that I have 900 dollars, I wont be thinking about that time when I withdrew
100 dollars. And this is the model of computing that is more pervasive today, where you have
variables that can be updated, so every time a new operation is received you load the current
value of the variable, perform the operation and store the result back on it. Instead of storing
all the operations and generate code dynamically you can do a dynamic dispatch of the operations
and use recursion, a very simple solution (that wont work distributed) is this one:

```
(define (account balance)
    (account
        ((readop) balance))

(account 0)
```

At first glance it seems pretty functional, but the complexity of handling dynamic operations
is hidden on **readop**, this is the function that will need some I/O to receive from somewhere
external to the system what operation needs to be executed, the order of operations will be defined
by time, the function has no saying on the order, and by definition it is not even a function
since this makes no sense in math, this is a procedure. And this is coupled with time and
is modeling it explicitly because it is time that will define the order that operations execute.

It reminds me more of real life, where people asks you to do stuff, and if someone asks you to do
the same thing sometimes the answer will be different from the previous one. At this point I go back
to concurrency, even when code is not concurrent itself, I/O models it, because on the world external
to the program concurrent things are happening, and the order that this
concurrent events happens outside the program will determine its outcome.

As Alberson said, it is a way to represent reality, object orientation reminds us more of how our
world works, there is a lot of independent agents, and sending the same message to them does not
guarantee that the result will be the same. Functional programming is a completely different way
to think, and when programming on a pure functional way the order of operations is completely
independent from time or any external interaction, it is defined by the code itself, that is why
is so easy to debug and analyze this kind of code, but it wont solve all your problems. One
very easy way to see that functional programming can be easier to understand and debug is that
correlation and composition is always explicit, when order doesn't matters this is explicit on
code. For example, on a purely functional lisp, this:

```
(+ 1 3)
(- 2 4)
```

And this:

```
(- 2 4)
(+ 1 3)
```

Will give you the same result, you can invert the order safely and when debugging you can be
**SURE** that there is no correlation between the two functions. When they are correlated the
code itself must express that, by using the result of one the operations as the parameter of
the other. Anyone familiar to programming with side effects and state knows that this not true
on the object oriented world, just changing the order of function/method calls that seem completely
unrelated can yield different results, through shared state or I/O interaction.


## Cool Quick Stuff

* High order functions as a way to separate concerns, isolate changes, avoid duplication and express patterns (so much for OO)
* I found another human being that dislikes mathematical notation as me, got happy :-) (Gerald Jay Sussman)
* Abstractions is a way to apply divide and conquer
