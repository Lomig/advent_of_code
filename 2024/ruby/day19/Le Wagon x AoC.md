# Le Wagon x Advent of Code — Solution Sharing
## Part One
* The puzzle literally asks us to check if we can find a set of patterns in a string. This is literally a REGEX!
  * if you want to check if everything is a digit in regex, you would check something like:
    1. `start` of the string
    2. Followed by a `digit`
    3. That is repeated `0 or more times`
    4. `end` of the string
  * you may write digits like this `\d` or `[0-9]`, but we can also make use of the `OR` operator, also called `UNION`
    * `0|1|2|3|4|5|6|7|8|9`
  * The puzzle is the same, but we have to replace digits with towels:
```ruby
REGEXP_FOR_DIGITS = /^1|2|3|4|5|6|7|8|9+$/
REGEXP = /^TOWEL_1|TOWEL_2|TOWEL3+$/
```

We just have to create this union of towels; Fortunately, the `Regexp` class in Ruby has a nice method for this.

## Part Two
The problem when you think you are too smart is that sometimes, you get caught at your own game.
* My `part 1` solution based on `REGEXP` is not useful at all here
* We will have to implement another algorithm

# Strategy
* We could naively count the number of possible associations of towels for each pattern, but as usual the input is purposefully too big to make this strategy efficient
* An idea is to cache this count for each sub pattern:
  * The more we iterate the more count we get without any computation, and the swifter the next computation will be
* We can count recursively from the smallest patterns to the biggest ones.

## Algorithm
We will use the same algorithm for each patterns and sum them up.



The algorithm will be recursive:
* If the pattern is `""` (nothing)
  * The number of possible composition is known: it's `1`
  * Possible compositions and their count are stored (caching strategy)
* If the pattern is cached, return the cached count
* If the pattern is not cached:
  * Take the towels that can compose the first stripes of the pattern
  * For each towel
    * Compute recursively the count of the pattern minus this towel
    * Sum those counts
