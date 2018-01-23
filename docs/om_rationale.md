# Om Language Rationale

## Executive Summary

**Om** is an object-oriented language optimized for the message expression.
The syntax is RPN as a convenient way to express the message expression.
Why all the focus on the message expression?
Because the purpose of a programming language 
is to solve a problem by writing code.
And because in an object-oriented language all code is encapsulated
in the body of a method which responds to a message to an object.

The name of the language is an abbreviation for

```
object message
```

## Om Language Principles and Features

+ Pure object-oriented. Protoype-based?
+ Optimized for the message expression. Say more later.
+ RPN
  + a convenient way to supply arguments
    and capture return values from a message expression
  + easy to implement
+ A message expression can be a symbol or a block of code (a quotation).
+ Support for quoting and and unquoting
+ Binding a value to a symbol
+ Symbol table resolution is just evaluation of a symbol
  in the context of an object
+ Evaluation is syntactic sugar for a message expression to **self**,
  in the context of some object
+ Interpreted
+ Transparency - all objects used to build **om** available to user
+ Bulit-in types:
  + symbol
  + boolean. Boolean constants are implicit.
  + integer
  + string. Abstractly a string is merely an array of characters.
  + quote
  + array
  + map (hash)
  + object (user-defined). Prototype-based?

## Message Expression and the Object Paradigm

## Object Paradigm

**Warning**:
It is assumed that the reader is acquainted with the object paradigm.
What follows is a quick summary of it,
torqued in the direction of the **om** language.

+ An object is a thing with a state that varies over its lifetime. 
+ An object has a public interface of messages that it can respond to.
+ The only way to inspect or modify an object's state 
  is to send it a message. 
  Thus the structure or implementation of object state 
  is hidden from all save the object itself.
+ A type or class is a collection of objects 
  which have the same public interface, 
  and behave in the same way in response to a message.
+ A type is an object, namely a factory
  for objects that all behave in the same way.
+ An application or system is a collection of objects -
  often of different types -
  that get the work done by sending each other messages.
+ The system is an object.

### When the message is a symbol

The general form of the message expression is

```
args object symbol .
```

For example

```
1 2 add .
"yields the value 3 on the top of the stack" comment :
```

In the above, **:** binds the symbol **comment**
to the literal string constant and pops it off the stack.
The binding takes place in the current context (object).
There is nothing special about the symbol **comment**.
But it is a nice convention for inserting comments in your code
without having to create an explicit comment syntax.

It's also a way to pop a value into an unused variable.

### When the message is a Quote

In the example above, 
the parser acts immediately on all elements, 
pushing popping and computing.
If you want to defer computation,
you can quote a sequence of **om** elements

```
[ 1 2 add . ]
```

and the interpreter simply pushes the quotation unto the stack.
To evaluate a quote, simply

```
[ 1 2 add . ] #
"yields the value 3 on the top of the stack" comment :
```

When We send a quote as a message to an object, 
the entire block (the quote, that is) 
is executed in the context of the receiving object.
For example

```
stk # [ 
  3 push #
  4 push #
  pop #
] .

app # [
  "om_code.om" file # f :
  f # read . to_quote # #
  f # close .
] .
```

What we have above is a possible fragment of the **om**
compiler, parsing and executing a file of **om** code.


## Om language Interpreter

The basic idea:

+ There is an **App** object
  + After all, the point of programming is to build an app.
+ It translates the program (a string)  into a quote
+ it evaluates the quote against itself as a message

This works both for

+ reading an **om** program from a file and executing it
+ Inter-active command line interpreter, like irb,
  call it **iom**.

## Quoting and Unquoting

## Binding and Evaluation

## Om Typology

### Symbol

### Boolean

### Integer

### String

### Quote

### Array

### Map (hash)

### Object (user-defined)

## Specification and Test

TDD baked in!
