# Le Wagon x Advent of Code — Solution Sharing
As predicted, the naive algorithm from `part 1` is not performant enough to ensure a swift solution for `part 2`.
We need to find a better solution

## Strategy
* It takes time to compute how many stones a single stone will produce after `x` blink
* BUT maybe a stone that will be divided in 2 stones will create stones that we already computed beforehand?


So, let's try a 2-fold strategy:
* Compute the number of stone a single stone will produce after X blink
* While doing that, cache the result of this calculation to be reused if need be


We will use a recursive algorithm to ensure that each divided stone at each step of the algorithm is cached as well.
* The number of stone that will be spawned in `x` blink from a single stone is the number of stone that will be spawned by its children in `x - 1` blinks
    * When a stone spawn children through a blink, there can be one child or two children

## Special Methods and Syntax
* As per the algorithm above, I want to iterate on children spawned from a stone.
    * But it can be a single stone, we cannot iterate on something that is not an Array!
    * Introducing `Array()`
```ruby
Array([1, 2, 3, 4]) == [1, 2, 3, 4]
Array(nil) = []
Array(2) == [2]
```
