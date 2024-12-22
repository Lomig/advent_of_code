# Le Wagon x Advent of Code — Solution Sharing
## Part One
### Introduction
This year yet again let's take this AoC as an excuse to talk about methods and patterns it could be useful to know, and good practices.

For beginners, one of the first challenges is to parse a file. As it's always the same, I would extract that for not having to do it again and again each day.
Thus, my `AoC` parent class.

### Learning Points
#### Clean Code
Let's start simple. We will follow the `Clean Code` principles. The idea is, when performance does not matter, to trade off some of the performance for readability and maintainability.
Today's application of the principle is in the length of methods. There are **2** rules :
* Methods should be short
* Methods should be shorter than that


Each short method with a very descriptive name let us follow what is done where.
Here, we have 1 line methods most of the time. I enforce this through the usage of Ruby 3 one-liner method definition.

#### Special Methods

* `Array#transpose` will take an array of array — a 2-dimensional array — and exchange their "rows" and their "columns"
```ruby
[[:a, 1, :blue], [:b, 2, :green], [:c, 3, :red]].transpose == [[:a, :b, :c], [1, 2, 3], [:blue, :green, :red]]
```
* `Array#zip` takes another array, and zip it like the zipper of your jeans!
```ruby
["Lo", "Pil", "Aqu", "Joe"].zip(["mig", "ou", "aj", "nn"]) == [["Lo", "mig"], ["Pil", "ou"], ["Aqu", "aj"], "Joe", "nn"]]
```
* `Array#sum` is shown as a simple method during Le Wagon bootcamp, but it is an iterator: it takes a block, and for each element of your array, it will sum the result of the block.

## Part Two
The solution for the second puzzle naturally takes its roots into the solution from the first one.

### Learning Points
#### Special Methods

* `Array#group_by` will take an array and will put its elements in a hash, grouped by the result of the block
```ruby
[1, 2, 3, 4, 5].group_by { |n| n.odd? } == { true => [1, 3, 5], false => [2, 4] }
```
* `Object#itself` does... nothing. It returns itself. But with the `group_by`, it shows potential: We will group duplicates of the same element together!

* `Hash.default` change the default value of an `Hash`. You may be under the impression that asking for an absent key in a hash returns `nil`. Whereas it is the case in other languages, in Ruby it returns the `default` value, which is `nil` by default to mimic those other languages. Here, it is very useful, as I want to do arithmetics with some keys: I don't want to check if they exist, they just equals 0 if they do not.

Counting directly in the Array would be simple, but how would I get the occasion to talk about `group_by`, `itself` or `default` otherwise?  ¯\\\_(ツ)\_/¯
