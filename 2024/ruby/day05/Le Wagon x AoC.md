# Le Wagon x Advent of Code — Solution Sharing
## Part One
Today's puzzle is the first one that forces us to think about input parsing!

### With Object, or not With Object?
Today, the featured iterator is `.with_object`. It is a composable iterator; you can use any other iterator with a `#with_object` extension. There is a shortcut when used with `#each`
```ruby
a.each_with_object == a.each.with_object
``` 

`#each_with_object` is very similar to `#inject` we talked about [a few days ago](https://aoc.lewagon.community/day/2/1#1034): Whereas `#inject` comes from functional programming languages, we can consider `with_object` to be its Ruby rethink.
* it takes an argument with any object, that we call an accumulator
* during each iteration the accumulator is injected in the block **as the last argument of the block**
  * (`#inject` injects the accumulator as the first argument)
* the accumulator can be mutated or replaced from within the block itself
  * (with `#inject` the accumulator is replaced with the result of the block)
* the accumulator is returned at the end of the iteration.
  * same for `#inject`

Most people feel those differences as being easier to grasp, but every algorithm that is fitting for one can be done with the other.
My advice: If the accumulator is a `Hash` or a 2+ dimensional `Array`, use `with_index`, if it is a 1-D `Array`, choose what you prefer, else use `#inject`.

### All?

* `#all?` without a block just checks if everything is truthy.
* `#all?` with a block will return `true` if the block returns a truthy value for every iteration.

### References and Values
Ruby only refers to values. What does it mean? If you assign an object to a variable, this variable is just an "address" to find the object.
```ruby
a = [1, 2, 3]
b = a
b.shift

b #=> [2, 3]
a #=> [2, 3]
```
* It means that you need to be very careful when giving an object to a method as an argument: it may change it without you wanting it!
  * Try never to mutate any data to avoid any issue
* It can also be used to make your code clearer and simpler. In the code below, I split my accumulator for `with_index` and mutate each part, which mutates the accumulator itself.


### Miscellaneous
* About splatting: Did you see the 3 occasions I used a splat array?
* I used a lambda as an iterator method as discussed a previous day
* We can rescue some code lines to replace any error with a value. What if a page was not included in the rules?

## Part Two

* I could have done a bubble-sort of pages until they comply to all rules.
* I could have done a topological sort of rules and pages.

... but that would have meant explaining sorting algorithms here, and did I have the courage?
Am I not lazy as frack?

So I had to be clever.


So, let's simplify the problem:
* There are too many rules. Let's ditch rules that do not talk about pages for a given manual.
* If I have a set of all rules, and if I look at only the first part of the rule:
  * The more rule there is with a page `x` as the first part, the further right this page should be.

  
Given the above, we can index pages without proceeding to any sort! Example:
* 4 rules say that the page `x` should be before other pages
* The index of this page is then the `length of the manual - 4`, and `minus 1` to index from 0.


... The solution is as simple as finding the page with this index being the middle one.
