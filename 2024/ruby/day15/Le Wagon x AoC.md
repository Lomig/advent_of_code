# Le Wagon x Advent of Code — Solution Sharing
## Strategy
* We gather all blocks that should move with the Robots
  * As an element may move 2 others (its other part forming a `Crate`, and the block in the direction of the push), I decided to go as usual for a Graph Traversal I already talked about for 2 puzzles this year
  * If a wall is a part of those movable items, nothing can move
* We remove those blocks from the Warehouse
* We put them back, moved by 1 block in the correct direction

## Special Methods and Syntax

### Factories
* Proper OOP rarely uses conditionals outside of `Factories`
  * A Factory is a Class / a Class Method that will choose and create a class for you


Before Factory:
```ruby
if symbol == "#"
  warehouse[row, column] = Wall.new(row, column, warehouse)
elsif symbol == "@"
 warehouse[row, column] = Robot.new(row, column, warehouse)
elsif  symbol == "O"
 warehouse[row, column] = Box(row, column, warehouse)
end
```


After Factory:
```ruby
warehouse[row, column] = LocationFactory.from_symbol(symbol, row, column, warehouse)

class LocationFactory
  LocationTypes = {
    "#" => Wall,
    "@" => Robot,
    "O" => Box
  }

  def self.from_symbol(symbol, row, column, warehouse)
    LocationTypes[symbol].new(row, column, warehouse)
  end
end
```

I did not use a factory class but directly my `Location` class, and I like using `#[]` as creation methods.

### Class Methods

You can declare Class Methods in a lot of ways in Ruby

```ruby
class MyClass
  def self.my_class_method1
    # something
  end
  
  def MyClass.my_class_method2
    # something
  end

  class << self
    def my_class_method3
      # something
    end
  end
end

class << MyClass
  def my_class_method4
    # something
  end
end

def Myclass.my_class_method5
  # something
end
```
