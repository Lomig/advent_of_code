# Le Wagon x Advent of Code — Solution Sharing
## Part One
A Christmas Tradition for AoC, a long-last favorite for any game programming, here it comes, our first Graph Traversal Algorithm!

### Graph Traversal
#### Once upon a time, Google Maps
Graph traversal is way older than Google Maps, but I find it a very good example for people to grasp the concept.

Imagine you want to go from Paris to Berlin, and you ask your GPS for a path and its distance. How does it find it?
* It goes up to the first street intersection; it can go left or right.
* Am I already in Berlin? Nope! So it'll have to choose... but it'll have to check both anyway...
* It stores in a queue "From this intersection I went through all this previous path, and I am going right".
* It stores in the queue "From this intersection I went through all this previous path, and I am going left".
* ... and it loops back at the beginning of the algorithm, checking the next location and direction in the waiting queue.

At each intersection, multiple elements are added to the queue and it grows up until one intersection is already in Berlin.
Graph traversal is that simple!

#### BFS algorithm
* BFS stands for Breadth First Search. To get back to the example, it means that we will check the left and the right part of the intersection before going deeper in our traversal.
* Regarding the simple algorithm described above, it's the type of search that is happening when you put your new elements at the end of the queue: You go deeper in the tree AFTER you checked everything at a less deeper number of intersection

#### DFS algorithm
* DFS stands for Depth First Search. To get back to the example, it means that we will check the left, then the left at the next intersection, then the left... all down to meet Berlin or fail (cul-de-sac!) before going back into the tree to check the right path.
* Regarding the simple algorithm described above, it's the type of search that is happening when you put your new elements at the beginning of the queue: You look around in the tree AFTER you pursued a path to the deepest level

#### Dijkstra's algorithm
HEY THIS IS OUR MASCOT FOR LE WAGON AOC !!!!
* It's a Dutch name, you can pronounce it 'Dyke' 'Strah'
* Dijkstra is just BFS with a "weight" to each path to priorise some over others. In the case of Google Maps, we will check motorway before dirt roads, for example.

#### A*
Not very relevant for this puzzle, as I discussed Google Maps, let's be quite complete:
* Trying to going from Paris to Berlin through Italy will never lead to the shortest path
* Dijkstra is not enough to compute the shortest path in an efficient way, because every path is kept on the table
* A* (pronounced A-star) algorithm will give a global direction to the search: it tries first nodes that are in the direction of Berlin.

### But what is the relevance?

The biggest difficulty in Graph Traversal algorithm is not how to implement them: really, the algorithm is stupidly simple. The main problem is to **see** that it would help us.
* For location issues, maps,... it's quite easy to recognise the pattern
* For other problems... all is tied to states.

We can see each node of a graph like a state. (A mathematician will call them nodes, but a game developer will call them states anyway)
* The state is a picture of your problem at a certain point
* The path between states is what makes the state change. It can be time, distance, but anything else really.

So here, what do we have?
* Our state is
    * the numbers already used for the equation
    * the result of this partial equation
    * the numbers still available for the next evolution of our state
* Our paths are the different operation we can apply to the available numbers


```text
Initial State for 3267: 81 40 27
             ┌──────────────────────────┐
             │ value_to_reach: 3267     │
             │ value_reached_so_far: 81 │
             │ numbers_available: 40 27 │
             └──────────────────────────┘
                           │
           ┌───────────────┴──────────────┐
           │                              │
        Path: +                        Path: *
           │                              │
           ▼                              ▼
┌───────────────────────┐     ┌───────────────────────┐
│ value_to_reach: 3267  │     │ value_to_reach: 3267  │
│ value_reached_so_far: │     │ value_reached_so_far: │
│   121 (81 + 40)       │     │   3240 (81 * 40)      │
│ numbers_available: 27 │     │ numbers_available: 27 │
└───────────────────────┘     └───────────────────────┘
```

### Special Methods and Syntax
* Data.define(:foo, :bar) will create a class with `attr_reader` `:foo` and `:bar`.
    * It's like a `Struct` but with no `attr_writer`: it is immutable
    * It is a value object: Equality is based on its content, not on its object_id
    * We can instantiate it in a lot of ways:
```ruby
Money = Data.define(:amount, :currency)

Money.new(amount: 10, currency: :eur) == Money.new(10, :eur)
Money[amount: 10, currency: :eur] == Money[10, :eur]
```
* `an_array[4..]` will return an array with all elements of `an_array` but the 4 firsts.
* `something.send(:foo, :bar) == something.foo(:bar)`
* In Ruby, everything is an object, and `+` does **not** exists. You learn it that way for people coming from other languages not to be afraid.
    * As everything is an object, the only thing we can do is sending them messages (aka calling methods on them)
    * Numbers are objects of the class `Integer` (or `Float`, but whatever)
    * Therefore, the only thing we can do to numbers is sending them some message.
    * The addition in Ruby is a method `Integer#+`
```ruby
4.+(5) == 9
```
* The opportunity to remove the `.` and replace it with a space is just syntactic sugar!
* ... it means I can use it as any other method, including when mixed with `#send` from above

## Part Two
* There isn't any difference between the previous `part` and this one
* We just need to add an operator.... that does not exist for Integer.

Well, let's just add it!

That is call monkey patching, and it is one of the strength of Ruby 😊