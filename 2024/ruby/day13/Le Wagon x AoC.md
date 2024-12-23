# Le Wagon x Advent of Code — Solution Sharing
Well... Today is Math.

More precisely, today is Algebra.

More precisely, today is Matrix Computation.

... and I am sorry, but I'll give you some math then 😅

## The Puzzle
### Making it a Math problem
For non-mathematician, the first difficulty is to understand that `X` and `Y` from the input are not the math traditional `x` and `y` unknown entities.
```text
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400
```

* Each time I press A, it goes left `94`
* Each time I press B, it goes left `22`
* We need to go left `8400`
  The problem can be put as:
* Let `x` be the number of time I push the A button,
* Let `y` be the number of time I push the B button,
  Then the problem can be expressed as `94x + 22y = 8400`



Following the same logic for the other direction, we got a set of 2 equations with 2 unknown entities.
```text
94x + 22y = 8400
34x + 67y = 5400
```

### Solving the Math problem
In France we are taught how to solve system of linear equations around being 14 or 15, and I guess it is the same thing for other countries, approximatively.
* We manipulate each equation a certain way, we subtract, we add things...
* IT IS POSSIBLE to do so in an algorithm, but later in the Math program, we can be taught about Matrices, and they can be used to solve those problems in an easier way.
* As Ruby has already a `Matrix` class, I will prefer this method.
* You can check this very neat solution below to use the traditional math without matrices:
  * [https://aoc.lewagon.community/day/13/1#1477](https://aoc.lewagon.community/day/13/1#1477)
  * Congrats Jules 🌹

### Expressing the problem with matrices
The idea is not to explain into details how it works, but it is quite easy, so anyone can learn; you can check a video on YouTube if interested.
* We transform the 2 equations in 3 Matrices, as `A * X = B`, searching for `X`
```text
    ┌       ┐      ┌   ┐      ┌      ┐
    │ 94 22 │      │ x │      │ 8400 │
A = │ 34 67 │  X = │ y │  B = │ 5400 │
    └       ┘      └   ┘      └      ┘
```
* Matrix equations are like any equation: I can divide every side by the same amount and keep the equality.
* Dividing is the same thing as multiplying by the inverse
```text
         A * X = B
inv(A) * A * X = B * inv(A)
         1 * X = B * inv(A)
```
* And that's it! Well you still have to know how to do an inverse of a matrix, and how to multiply matrices, if you want to resolve it yourself
* (as I said, it is quite easy, but out of scope here)

### Solving the algorithmic problem
* Fortunately, as I said, Ruby already has a built-in `Matrix` class!

```ruby
require "matrix"

a = Matrix[[94, 22], [34, 67]]
b = Matrix[[8_400], [5_400]]

solution = a.inverse * b
push_button_a_count = solution.to_a.flatten.first
push_button_b_count = solution.to_a.flatten.last

```

## Special Methods and Syntax

### Anonymous block arguments
* Those 2 blocks are equivalent:
```ruby
{ |a, b| a.do_something(b) + b }
{ _1.do_something(_2) + _2 }
```
* In `Ruby 3.4` (coming this Christmas!), when the block takes a single argument, we will be able to use `it` for... it.
```ruby
array.each { |element| puts element }
array.each { puts _1 }

# !!! Only in Ruby 3.4+
array.each { puts it }
```

### Rational
* You know `Integer` and `Float` as classes of numbers in Ruby, but there is also `Rational`
* It is used to represent... rational numbers, you guessed it!
```ruby
Rational(2, 3) #=> 2 / 3
Rational(4, 6) #=> 2 / 3
6.to_r         #=> 6 / 1
```
* Matrix operation produces rational numbers and we will need to convert them
* If the solution of the equation is not an integer, it means that winning is not possible
