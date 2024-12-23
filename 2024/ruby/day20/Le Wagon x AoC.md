# Le Wagon x Advent of Code — Solution Sharing
## Part One
* We can race and fine the shortest path quite easily with a BFS or DFS algorithm, as for a few puzzles this year already
* Cheating is just removing a wall:
  * Remove a Wall
  * Raee
  * Initial Race - New Race == Time saved
* The problem with this approach is that it needs too much computation time, it does not work!



And here comes back the third Graph Traversal Algorithm: our beloved Dijkstra!
* We compute for **_each_** node of the race its distance from the start
* 2 neighbours have a distance difference of `1`
* Removing a wall is changing those distances:

```TEXT
Before:

         [Wall]                   [Wall]          [Wall]            ...
[Node at 4 steps from S] [Node at 5 steps from S] [Wall] [Node at 18 steps from S]
         [Wall]          [Node at 6 steps from S] [Wall] [Node at 17 steps from S]
                                    ...           [Wall]            ...


After:

         [Wall]                   [Wall]          [Wall]            ...
[Node at 4 steps from S] [Node at 5 steps from S] [Wall] [Node at 9 steps from S]
         [Wall]          [Node at 6 steps from S] [7 s ] [Node at 8 steps from S]
                                    ...           [Wall]            ...
```

* We never have to recompute the race, then
   * For each `Wall` with 2 neighbours A and B, we do `B - A - 2` to find the difference!
   * `- 2` because we added a Node in place of the wall, so we have to enter this node and then leave it, which adds 2 steps!
* I only look at Walls with 2 normal nodes around them, any other will not provide any shortcut
* In my algorithm, I keep track of the path as an habit, it's not useful. It may become useful for `part 2`?

## Part Two

### Manhattan Distance
* The Manhattan Distance or Taxi Distance is the distance between 2 points when we are forced to move on perpendicular straight lines, like a taxi in Manhattan.
* On a grid when no diagonal moves are allowed, it's the distance on the `y` axis + the distance on the `x` axis
* All distances and "time savings" since `part 1` have been Manhattan distances

### Algorithm
* `part 2` is no different from `part 1`: it just asks to **_generalise_** your solution
  * `part 1`: Take a node `n1` of a path, look around for a node `n2` moving up to `2` nodes. If it's not a wall, (distance from start to n2) - (distance from start to n1) - 2
  * `part 2`: Take a node `n1` of a path, look around for nodes `n2`, `n3`, ... in neighbours up to `20` nodes apart. If it's not a wall, (distance from start to nX) - (distance from start to n1) - (distance from nX to n1)


So the idea is:
* Compute the best `path distance` like in `part 1`, but keeping the `best path` as well as the `best distance` (Good thing I did it in advance!)
* For each `Node` `n` of the path:
  * Take all `nodes` within `20` Manhattan distance: they are the nodes where the cheat can be deactivated.
  * Remove walls as we cannot deactivate within a wall
  * For each `Node` `a`, Compute `distance(a -> start)` - `distance(n -> start)` - `distance (a -> n)`
  * Count those above 100.
