# Le Wagon x Advent of Code — Solution Sharing
## Part One

As usual, I don't talk a lot about how my input is parsed, as I abstracted that away a long time ago.
* `input` by default is given as an array of lines
* you can choose another format if it suits better, like a matrix or a raw string
* you can use a lambda as a formatter for simple transformation, like mapping to integer

Regarding the rest of the code, a few original methods and ways!

### Lambdas, Methods and Iterators

You probably know that iterators take a `block`:
```ruby
my_array.each { |element| do_something_on_element(element) }
```

A classical shortcut is possible when what we do is just calling a method on this element, without any argument:
```ruby
my_array.each { |element| element.to_i } == my_array.each(&:to_i)
```

But you can also provide a named method from the class you are in if you want and as demonstrated in my solution:
```ruby
def my_method
  my_array.each { |e| do_something_on_element(e) }
end

def my_synonym_method
  my_array.each(&method(:do_something_on_element))
end

def do_something_on_element(element)
  # Doing Something
end

my_method == my_synonym_method
```

As a matter of fact, `&` is a special operator that basically transforms a method into a lambda... which implies that an iterator can also take a lambda!
(A lambda is an anonymous function, that can be put into a variable, taken as an argument or returned by another function)

```ruby
def my_method
  a_lambda = ->(e) { do_something_on_element(e) }
  my_array.each(a_lambda)
end

def the_way_lomig_uses_lambdas_with_iterators
  my_array.each(do_another_thing_on_element)
end

def do_another_thing_on_element = lambda do |element|
  # Doing Something
end

my_method == my_synonym_method
```

### Methods

* `#each_cons` will iterate like `#each`, but taking the next element and its nth neighbours
```ruby
[1, 2, 3, 4, 5].each_cons(3).to_a == [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
```

* `#inject` takes an argument called an *accumulator*, will give the argument to the block *as the first parameter*, and will replace the accumulator with the result of the block for the next iteration.
```ruby
["W", "o", "r", "l", "d", "!"].inject("Hello ") { |acc, char| "#{acc}#{char}" } == "Hello World!"  
```

It is (secretly) the main iterator with `#map` in the world where they have been invented!

Fun fact (for me, because I am a nerd): the `#sum` iterator we saw yesterday is just some sugar above `#inject`
```ruby
  my_array.sum { |e| e * 2 } == my_array.inject(0) { |sum, e| sum + e * 2 }
``` 

* `#any?` with no block just checks if at least one of the element of your array is truthy.

### Block arguments

Blocks let you split array arguments to name their parts. You use this for `Hash`, but without knowing it!


```ruby
my_hash.each { |e| puts "key #{e[0]} has value #{e[1]}" }
my_hash.each { |k, v| puts "key #{k} has value #{v}" } # the array e has been splat
```

I used this splat operation to make my `#inject` accumulator more readable!

## Part Two
### Methods

Nothing fancy here but for `Object#tap`.

It will take a block as an argument, and throw what it has been called upon as an argument of the block.
It will then return what it has been called upon.

It is useful when you want to do something with an object without losing it.

```ruby
def log(something)
  if send_to_logging_software(something)
    congratulates
    true
  else
    false
  end
end

my_element
  .do_something
  .tap { |element_after_something| log(element_after_something) }
  .do_something_else_on_element
```