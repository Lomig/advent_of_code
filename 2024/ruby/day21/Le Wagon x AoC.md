# Le Wagon x Advent of Code — Solution Sharing
## Strategy
* As we have several robots in a row, I **_know_** that the `part 2` will be about adding more intermediate robots.
  * Let's plan for that.
  * Let's talk about `depth` when talking about them
* Each time you move on a keypad, **at best** we will add 2 moves one keypad deeper: the movements to push `A`
  * It means that for each depth, we only care about the shortest paths
* Not counting the first keypad, all of them are identical, and each movement starts and finishes at `A`
  * It means that movements are independents
  * It means that somewhere there is a `Hash` with keys being a set of movements, and values the corresponding best set of movements one keypad deeper
  * You could use that info to compute directly the `Hash`. I decided to use it to create a `cache` dynamically while iterating through keypads

## Algorithm
* For each key, we will compute the shortest paths to other keys (Dijkstra / BFS / DFS as everyday)
  * The path to itself is just `A`, ensuring with order to push the `A` button at the end of each sequence
* RECURSIVELY: `keypad 1` (the numerical one)
  * As we start on `A`, add `A` at the beginning of the sequence
  * For each pair of keys in the sequence:
    * take the shortest paths between those keys
    * RECURSIVELY: use those paths as sequences for `keypad 2`, and then `keypad 3` to find deeper paths
    * If it's the last keypad, they are already the deeper paths
    * Take the shortest of those paths
  * Cache the value

## Recursion and keypads
Let's talk about keypads!
* There are 2 kinds of them, I don't like it
* You could imagine having a unique one, joined by the `A` row
* You just need to replace `0` in the input by `^`
* It's not necessary, with 2 keypad types you would just have to do a special condition in your recursive method, or deal with the Numerical Keypad beforehand

```text
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
```
