# Fibonacci Numbers

## The Fibonacci function is defined as:
```
fib(0) = 0
fib(1) = 1
fib(x) = fib(x-1) + fib(x-2) when x > 1
```
A C program and an AMD64 assembly program that calculates the x-th Fibonacci number defined above and prints the result as shown in the interactions below. 

## Sample interactions:
```
$ ./afib 0
fib(0) = 0
$ ./cfib 10
fib(10) = 55
$ ./afib
Usage: ./fib N, where N >= 0
$ ./cfib -4
Usage: ./fib N, where N >= 0
$
```
Used the naive implementation with a fib function that makes two recursive calls. Invalid input should print a usage message.

# Command Line Calculator
A C program and an AMD64 assembly program that take a simple arithmetic expression on the command line and print the result formatted as shown in the interactions below. 

## Sample interactions:
```
$./acalc 1 + 4
1 + 4 = 5
$ ./ccalc 2 "*" 7
2 * 7 = 14
$ ./acalc 2 / 70
2 / 70 = 0
$ ./ccalc
Usage:
  ./ccalc N op N
  $ ./acalc 2 AND 7
  Usage:
    ./acalc N op N
```
Supports the following arithemetic operations on long integers: (+, -, *, /). Invalid input should print a usage message.
