# Le Wagon x Advent of Code — Solution Sharing
## Part One
Well, nothing fancy to share for `part 1`, just pure fun!

### Exceptions
* Instead of checking if the pointer goes out of the input or not, and handle case here, I decided to raise an exception
   * `raise` just produce an error, like `NoMethodError` you've seen a lot during your Wagon days, it's not just to show a console in your WebApp!
   * If you want an exception not to crash your program, you need to **_catch_** it: this is where `rescue` appears
* When an exception is raised, Ruby will execute what is in the `raise` section of the method which applies to the error classe
   * If there is no rescue to apply, it checks in the calling method, and in its calling method, etc
   * If nothing is rescued, then it will crash as usual

### Send
* Every class in Ruby inherits from Object if not specified otherwise.
* `Object#send` executes the method named as its first param
```ruby
"advent of code is awesome".send(:capitalise) == "advent of code is awesome".capitalize

4 + 3 == 4.send(:+, 3)
``` 
* It is useful when you want to execute a method, but you do not no which one when you write the program

### Miscellaneous
* `String#delete_prefix` will remove a substring if it is at the start of the main string.
* `#delete_suffix` exists as well

## Part Two
This would be an impossible puzzle for a lot of people, so instead of giving you just the algorithm (that would be USELESS); I'll take to to how I found the solution.
Don't hesitate to poke me on Slack if something is too swift or unclear.

### Getting to the solution
#### From Part 1 to Part 2

Part 1 is called sometimes a `Fantasy Computer`: We simulate the internal working of a computer that never existed.
* If you want to find yourself in this rabbit hole, there are Fantasy Consoles out there, like https://www.lexaloffle.com/pico-8.php
* You can imagine the input as the binary executable of the program, and instructions you generated from it as some kind of Assembly code


So we could test each values for `Register A` from 0 up until we found what we want, but the solution is so far away that it is not possible!
* We cannot reach a way to find the solution before understanding what the program **_does_**
* We need to `decompile` this binary code.

#### Decompiling our programm
* If you want to follow you may want to look at my solution for `part 1`: [https://aoc.lewagon.community/day/17/1#1576](https://aoc.lewagon.community/day/17/1#1576)
* The idea is to add a `@compile` array that will store all instructions and values that have been computed
```ruby
def decompile
  loop do
    input = INSTRUCTION_SET[next_input]
    @decompile << input
    send(input)
  end
rescue Halt
  @decompile
end

def combo(operand)
  if @decompile.any?
    @decompile[-1] = "#{@decompile[-1]} #{[0, 1, 2, 3, :A, :B, :C, :unused][operand]}"
  end

  [
    0, 1, 2, 3, @register_a, @register_b, @register_c, :unused
  ][operand]
end

## Example of change I made to an instruction using a normal operand
def bxl
  operand = next_input
  @decompile[-1] = "#{@decompile[-1]} #{operand}" if @decompile.any?

  @register_b ^= operand
end
```

And here is what I got:
```TEXT
bst A
bxl 1
cdv B
adv 3
bxc
bxl 6
out B
jnz 0
bst A
bxl 1
cdv B
adv 3
bxc
bxl 6
out B
jnz 0
bst A
bxl 1
cdv B
adv 3
bxc
bxl 6
out B
jnz 0
[...]
```

... and I can see there is a loop of `8 instructions` that is repeating itself 9 times, whereas my previous solution was 9 numbers.


#### Analysing the Assembler Code
Let's take this loop and pseudocode it:
```ASM
bst A // B <- A % 8
bxl 1 // B <- B XOR 1
cdv B // C <- A / 2^B
adv 3 // A <- A / 2^3
bxc   // B <- B XOR C
bxl 6 // B <- B XOR 6
out B // OUTPUT <- B % 8
jnz 0 // GOTO START IF A != 0 - This is the reason for the loop!
```

* First 3 instructions of my loop are settings `B` and `C` based on the value of `A`
   * All depends on `A` indeed
* `adv 3 // A <- A / 2^3` change `A`, but `A` is never used nor changed after that
   * It means it is changed only for the next iteration of the loop
   * I can move it at the end for more clarity



I don't want to go into checking the bitwise operations and understand what they do, but I can see another pattern I know here, the powers of `2`
* Integer Dividing a number by a power of `2` is just cutting some bits at the right of it
* We call this operation a (right) shift (`>>`)
```TEXT
Example : 2963 / 2³ = 2963 / 8
2963 / 8 = 370

In binary format:
2963 = 101110010011
370  = 101110010    ==> We removed the last 3 bits!
```

Let's simplify our pseudocode:
```ASM
bst A // B <- A % 8
bxl 1 // B <- B XOR 1
cdv B // C <- A >> B
bxc   // B <- B XOR C
bxl 6 // B <- B XOR 6
out B // OUTPUT <- B % 8

adv 3 // A <- A >> 3
jnz 0 // LLOP
```

And here we have everything we need to find the solution, as my loop is:
```TEXT
LOOP
  CALCULATE_SOMETHING(A)
  A <- A >> 3

  BREAK IF A = ZERO
END_LOOP
```

* Before `A` can be `0`, it was at maximum `111`
   * It means the algorithm in reality only cares about those 3 last bits
   * Note that `111` is `7` in decimal: For the last iteration, A is between 0 and 7.

### Algorithm
* Starting from the end of the input, for each element
   * For first element :
      * Try all numbers from 0 and 7: Put it in the `A` register of the `part 1` computer, and run it
      * Keep only those candidates where the first output of the `part1` computer equals the element
   * For all other elements :
      * For all previous candidates:
      * left-shift (`<<`) the candidate, the opposite of the right shift!
      * Do as for the first element, putting in the `A` register (`shifted_candidate` + number from 0 to 7)
* Take the smallest candidate at the end of the iteration

### Going Further
* First element of input and other elements can be dealt with the same way if we consider that the first candidate is `0`
   * (0 << 3) + numbers from 1 to 7 does not change the number
* The algorithm from above is enough, but the Fantasy Computer is ever so slow!
* As I have the pseudocode, I can do my own version of the algorithm in my main language.
* This is what will be my code at the end, but it's exactly the same thing as above, just replacing the computer with an optimised version of it

Let's create this optimised algorithm then. We were here:
```ASM
bst A // B <- A % 8
bxl 1 // B <- B XOR 1
cdv B // C <- A >> B
bxc   // B <- B XOR C
bxl 6 // B <- B XOR 6
out B // OUTPUT <- B % 8

adv 3 // A <- A >> 3
jnz 0 // LLOP
```

Lets' regroup some of those instructions (in several steps)
```ASM
bst A bxl 1 // B <- (A % 8) XOR 1
cdv B       // C <- A >> B
bxc         // B <- B XOR C
bxl 6 out B // OUTPUT <- (B XOR 6) % 8

adv 3       // A <- A >> 3
jnz 0       // LOOP
```

```ASM
bst A bxl 1       // B <- (A % 8) XOR 1
cdv B             // C <- A >> B
bxc   bxl 6 out B // OUTPUT ((B XOR C) XOR 6) % 8

adv 3             // A <- A >> 3
jnz 0             // LOOP
```

```ASM
bst A bxl 1             // B <- (A % 8) XOR 1
cdv B bxc   bxl 6 out B // OUTPUT ((B XOR (A >> B)) XOR 6) % 8

adv 3                   // A <- A >> 3
jnz 0                   // LOOP
```

Which can finally be converted into 2 small Ruby methods:
* The first one compute 1 output digit
* The second one is the ENTIRE computer from `part 1` (I won't need that part for solving `part 2` though)

```ruby
def output_digit(a)
  temp = (a % 8) ^ 1
  
  ((temp ^ (a >> temp)) ^ 6) % 8
end

def compute(a)
  output = []
  loop do
    output << output_digit(a)
    a = a >> 3
    break output.join(",") if a == 0
  end
end
```
