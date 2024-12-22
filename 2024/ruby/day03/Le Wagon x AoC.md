# Le Wagon x Advent of Code — Solution Sharing
## Part Two
### return, next

In most languages implementing loops, `next` is a keyword meant to skip an iteration, but not breaking entirely of the loop.
Whereas Ruby copies this behaviour, yet again it attaches a different concept there, and just mimics the others.

Lambdas (anonymous functions ands blocks, check my solution on previous days) have a fundamental problems: Returns may mean a lot of different things:
* Do I want to return from the block, but the next iteration happens normally?
* Do I want to return from the iteration, stopping it completely, but the rest of the method happens normally?
* Do I want to return from the method altogether?

In Ruby, we defined 3 different keywords with 3 different scopes:
* `next` exits a block, and the next iteration will take place normally. `next :a` will make `:a` the return value of the block.
* `break` exits an iteration. `break :a` will make `:a` the return value of the entire iteration which is probably not the desired behaviour for `#map`, `#sum` or `#reduce`
* `return` exists the englobing method. `return :a` will make `:a` the return value of the method

In this puzzle, I want to do the sum of the computed operation, but only if there is a computed operation and only if we have this `do()` operation: lots of occasion to use `next`

### Lazy Evaluation of Boolean
Ruby has some lazy-evaluation based features, quite not known.

A language is said lazy when it only computes values when they are needed, and not before.

```ruby
(1..1_000_000_000_000).select(&:even?).first(10)
```

...should only need to compute 20 numbers before returning the 10 first even numbers.
In a non-lazy language, it will not be the case though: the range for the 1_000_000_000_000 numbers will be stored in memory before only using the 20 first numbers and taking 10 of them.

Ruby is not lazy per default, but in 2 occasions:
* It can create lazy enumerators. We can rewrite the example from above just to compute the 20 needed numbers only:
```ruby
(1..1_000_000_000_000).lazy.select(&:even?).first(10)
```

* It proceeds with lazy evaluation of booleans.
    * If you check for `OR`, it will return `true` if AT LEAST one of your conditions does eval to `true`. If it is the case for the first one, we can return `true` directly as we do not care if the second one is true or not: it will not be evaluated.
    * IF you check for `AND`, it will return `false` if AT LEAST one of your conditions does eval to `false`.If it is the case for the first one, we can return `false` directly as we do not care if the second one is false or not: it will not be evaluated.

My solution *fights* the lazy evaluation of booleans to change the `processing` status and return `0` as the result of the block.

(How can we be driven to such an extreme to spare a single line of code? 😅)
