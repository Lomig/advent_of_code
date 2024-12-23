# Le Wagon x Advent of Code — Solution Sharing
## Part One
* We should not move the robot one move per one move; even though it could work here, chances are that the `part 2` will ask for too many moves in order to make us time out
* Teleport is the challenge: how do we cycle back to the other side of the bathroom?
  * When going above the length or the width of the bathroom, we just have to subtract it. There is a math operator for that, `modulo` or `%`!
  * When going below 0, it will heavily depend on which language you use 😢 (but Ruby does what we wish for)
```ruby
# Ruby, Python, 
-8 % 5 #=> 2

# Javascript, OCaml, Rust, Go, PhP, Swift, Java, C...
-8 % 5 #=> -3
```
* For languages mixing up the remainder of integer division and modulo, you would have to compute the new position yourself.
  * It's quite simple
  * The pseudocode would be something like
```
result <- x % y
if result >= 0 then result
else result + y
```

## Part Two

# Being Lazy, Being Adventurous
Reading other solutions, I feel like I cheated my way to the answer... 😅


I was sure it would be the end of my streak this year...
* First I panicked: I don't know what this Christmas tree looks like!
* Then I thought I was missing something else: AoC never let you do trials and errors looking at a shape in your terminal.


So I thought... that would be stupid for elves to create an easter egg, drawing a certain shape, if not all robots were involved.
* Hey, what if the Christmas Tree is drawn when none of the robots are on the same spot?


So here we are.
