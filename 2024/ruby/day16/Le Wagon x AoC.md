# Le Wagon x Advent of Code — Solution Sharing
## Part One

### Dijkstra

* [A few days ago](../day07/Le%20Wagon%20x%20AoC.md), I described Graph Traversal algorithm; I said they were simple, but sometimes some paths between states had "weight"
* As said then, Dijkstra is the solution in this case.

So why a weight?
* Because going `north` or `east` does not reward the same score: paths are weighted!

### Difference with other Graph Traversal Algorithm
There are not a lot, actually: For each state, we need to keep a `weight` we accumulated from the start of the traversal.
* Bonus: it allows us to make this algorithm more efficient than an unweighted one:
  * If you have a working branch that totalled a score of X, and if score cannot go down, then any state that did not reach the end with a higher score can be discarded directly without checking its children
* We still need to identify what is a state and what is a path
* The direction makes it not a standard Graph Traversal algorithm in any case 😊

```text
              ┌────────────────────┐
              │ coordinates: 13, 1 │
              │ direction: :east   │
              │ score: 0           │
              └────────────────────┘
                        │
          ┌─────────────┴──────────────┐
          │                            │
      Turning left                     │
       Moving (1)                   Moving (1)
          │                            │
          ▼                            ▼
┌────────────────────┐       ┌────────────────────┐ 
│ coordinates: 12, 1 │       │ coordinates: 13, 2 │
│ direction: :north  │       │ direction: :east   │
│ score: 1001        │       │ score: 1           │ 
└────────────────────┘       └────────────────────┘
```

## Algorithm

1. Set the best score overall as INFINITY. Each time a solution has a better score, it will be a better solution.
2. We are in a maze: we can arrive on a specific intersection from different directions, BUT ALSO from different paths
    * We need to keep also the best score for each intersection... and each position then!
3. Set a queue: In a real Dijkstra Algorithm, the queue is ordered by the best weight.
    * Here, there is no shame if you used a normal queue though
    * We call it a Heap, and it is implemented in external libraries in Ruby, which is why I did not use it as it is not very pedagogical.
    * (Python has it in its standard library though)
4. For each state of the queue:
    * Discard it if its score is greater than the best score overall
    * If the state is the final state, update the best score if it was better, and go back to the queue (maybe a better solution will come out)
    * If not, for each direction:
        * Do nothing if the next coordinates would send the reindeer in a wall
        * Do nothing if we are coming from this direction
        * Or create a new state in the Queue, with the new coordinates, the new direction we are facing and the new score

## Part Two
* `part 2` is just `part 1` where you keep track of the path leading to the finish line
* We have to keep track of multiple paths with the same score:
  * the main difference in the algorithm will just be some `<=` and `<` being exchanged!
