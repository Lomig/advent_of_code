# Le Wagon x Advent of Code — Solution Sharing
## Part One
* It can be done through a triple iteration, there is not need to know any specific Graph Algorithm
* This having been said, it is the perfect occasion to talk more about `Graphs`, because I just talked about traversal in previous days

### Graphs and Cliques
#### What's a Graph?
A graph is a data structure that consists of the following two components:
1. A finite set of `nodes` also called as `vertices`
2. A finite set of `paths`, also called as `edges`, which connect the nodes
    * If the edges have a direction, we call it a `directed graph`. If not, it is an `undirected graph`
    * A `directed graph` can see 2 edges between 2 nodes, one in each direction.
    * If the edges have a weight, we call it a `weighted graph`

A `tree` is a special kind of `graph`
* with no cycle
* where a node exists from which all other nodes are reachable
* with one edge only between 2 nodes

==> In this puzzle `computers` are `Nodes`, connections are `Edges`, and the list of computers and their connections is a `Graph`

#### What's a Clique?
A `clique` is a subset of a graph where all nodes are connected
```text
┌───┐   ┌───┐   ┌───┐   ┌───┐
│ 1 ├───┤ 2 ├───┤ 3 ├───┤ 4 │
└─┬─┘   └───┘   └─┬─┘   └───┘
  │               │
  └───────────────┘
```
* Unitary nodes are obviously cliques: `[1], [2], [3], [4]`
* A node and one of its neighbours are also cliques: `[1, 2], [1, 3], [2, 3], [3, 4]`
* Cycles are cliques: `[1, 2, 3]`

==> In this puzzle, groups of interconnected computers are `Cliques`

#### Maximal Cliques
* Quite intuitively, a `maximal clique` is a clique that cannot be extended by adding another node.
    * `[1]` in the `Graph` above can be extended by adding `2`, `3` or `4`, and it would still be a clique: It is not maximal
    * `[1, 2, 3]` is maximal: adding `4` does not form a clique as `1` is not connected to `4` for example
* In the graph above, the maximal cliques are `[1, 2, 3]` and `[3, 4]`

==> In this puzzle, we search and care for maximal cliques of size `3` or more

### Finding Maximal Cliques
#### BackTracking Algorithm
* A backtracking algorithm is an algorithm that tries to build a solution, and goes back, cancelling part of its calculations, if it leads to an unwanted result
* It's a well-known algorithm for human beings; when you are stuck resolving a Sudoku, and try putting a number, filling in the rest of the grid until you find a contradiction and remove everything: It's a backtracking algorithm!
* Finding maximal cliques is an example of a problem that can be solved with a backtracking algorithm
* Introducing: the `Bron-Kerbosch Algorithm`!

#### Bron-Kerbosch step-by-step
If you followed the conversation I had on Slack, you may already have checked it on Wikipedia; Or you may have checked solutions on Reddit, and understood nothing. I'll try to do better, as it's not very complicated in reality.
* We will work with 3 sets of nodes:
    * the `clique` we are building (called `R` by convention, I'll call it `potential_clique`)
        * `potential` because it's a backtracking algorithm, and it may be an invalid clique
    * the `nodes` we can still add to the clique (called `P` by convention, I'll call it `candidates`)
    * the `nodes` we have already checked and that are not compatible with the clique (called `X` by convention, I'll call it `excluded`)
* The algorithm is recursive and will call itself

1. If there are no more `candidates` and no more `excluded`, we have a `clique`! We can add it to the list of `maximal_cliques` and return
2. For each `candidate` in `candidates`:
    1. Create the `next_potential_clique` by adding the `candidate` to the `potential_clique`
    2. Create the `next_candidates` by only keeping the `neighbours` of the `candidate` from the `candidates` list
    3. Create the `next_excluded` by only keeping the `neighbours` of the `candidate` from the `excluded` list
    4. Call recursively the algorithm with the updated `next_potential_clique`, `next_candidates` and `next_excluded`
    5. Move the `candidate` from the `candidates` to the `excluded`

And that's it, but it does not really make it easier to understand what happens and how the eck it works, right? 😅


So let's visualize it with the example of the graph above.
* Each box represents a call to the algorithm
* The branches represent the recursive calls to the algorithm

```text
GRAPH:

┌───┐   ┌───┐   ┌───┐   ┌───┐
│ 1 ├───┤ 2 ├───┤ 3 ├───┤ 4 │
└─┬─┘   └───┘   └─┬─┘   └───┘
  │               │
  └───────────────┘     ┌───┐
                        │ 5 │
                        └───┘

FIRST STEP: All our nodes are candidates
I'll put a number to indicate the step we are at in each box

┌1─────────────────────────────┐
│  potential_clique: []        │
│  candidates: [1, 2, 3, 4, 5] │
│  excluded: []                │
└──────────────────────────────┘
```
* The heart of the algorithm:
    * For each candidate
        * Recursive call
        * Move the candidate from candidates to excluded 
```text
┌1────────────────────────────┐
│ potential_clique: []        │
│ candidates: [1, 2, 3, 4, 5] │
│ excluded: []                │
└──────────────┬──────────────┘   
               │
               │current_candidate: 1
               │potential_clique: []
               │candidates: [1, 2, 3, 4, 5]
               │excluded: []
┌2─────────────┴─────────────┐
│ potential_clique: [1]      │
│ candidates: [2, 3]  ◁--┬---┼---- only keep nodes that
│ excluded: []        ◁--┘   │     are neighbours of the candidate
└──────────────┬─────────────┘
               │
               │current_candidate: 2
               │potential_clique: [1]
               │candidates: [2, 3]
               │excluded: []
┌3─────────────┴─────────────┐
│ potential_clique: [1, 2]   │
│ candidates: [3]  ◁----┬----┼---- only keep nodes that
│ excluded: []     ◁----┘    │     are neighbours of the candidate
└──────────────┬─────────────┘
               │
               │current_candidate: 3
               │potential_clique: [1, 2]
               │candidates: [3]
               │excluded: []
┌4─────────────┴──────────────┐
│ potential_clique: [1, 2, 3] │
│ candidates: []              │
│ excluded: []                │
└─────────────────────────────┘
    candidates and excluded
  are empty: We have a clique!
╔═5══════════════════════════╗
║ MOVE CURRENT CANDIDATE (3) ║
║      FROM CANDIDATES       ║ 
║        TO EXCLUDED         ║ 
╚════════════════════════════╝ 
```
* Step `4` has returned without any recursive call, and we have our first maximal clique
* Step `5` is moving the candidate
* We are back to Step `3` in the `each`, but there is no more candidate
* It's the end of recursive calls for Step `3`, so we will now move the candidate `2` to the excluded
```text
MAXIMAL_CLIQUES: [1, 2, 3]

┌1────────────────────────────┐
│ potential_clique: []        │
│ candidates: [1, 2, 3, 4, 5] │
│ excluded: []                │
└──────────────┬──────────────┘   
               │
               │current_candidate: 1
               │potential_clique: []
               │candidates: [1, 2, 3, 4, 5]
               │excluded: []
┌2─────────────┴─────────────┐
│ potential_clique: [1]      │
│ candidates: [2, 3]         │
│ excluded: []               │
└──────────────┬─────────────┘
               │
               │current_candidate: 2
               │potential_clique: [1]
               │candidates: [2, 3]
               │excluded: []
┌3─────────────┴─────────────┐
│ potential_clique: [1, 2]   │
│ candidates: [3]            │
│ excluded: []               │
└──────────────┬─────────────┘
               ├──────────────────────────────────────────────┐
               │current_candidate: 3                          │current_candidate: Null
               │potential_clique: [1, 2]                      │potential_clique: [1, 2]
               │candidates: [3]                               │candidates: []
               │excluded: []              ╔══════════════════▷│excluded: [3]
┌4─────────────┴──────────────┐           ║                   │
│ potential_clique: [1, 2, 3] │           ║                   ▽
│ candidates: []              │           ║              End of Branch,
│ excluded: []                │           ║              Back to Step 2 after recursion
└─────────────────────────────┘           ║     ╔6═══════════════════════════╗ 
    candidates and excluded               ║     ║ MOVE CURRENT CANDIDATE (2) ║      
  are empty: We have a clique!            ║     ║      FROM CANDIDATES       ║
╔5═══════════════════════════╗            ║     ║        TO EXCLUDED         ║ 
║ MOVE CURRENT CANDIDATE (3) ║            ║     ╚════════════════════════════╝ 
║      FROM CANDIDATES       ╠════════════╝ 
║        TO EXCLUDED         ║ 
╚════════════════════════════╝ 
```
* As the branch behind Step `3` is over, we are back to Step `2`
* But now there are new things in the `excluded` set!
```text
MAXIMAL_CLIQUES: [1, 2, 3]

┌1────────────────────────────┐
│ potential_clique: []        │
│ candidates: [1, 2, 3, 4, 5] │
│ excluded: []                │
└──────────────┬──────────────┘   
               │
               │current_candidate: 1
               │potential_clique: []
               │candidates: [1, 2, 3, 4, 5]
               │excluded: []
┌2─────────────┴─────────────┐
│ potential_clique: [1]      │
│ candidates: [2, 3]         │
│ excluded: []               │
└──────────────┬─────────────┘
               ├──────────────────────────────────────────────┐
               │current_candidate: 2                          │current_candidate: 3
               │potential_clique: [1]                         │potential_clique: [1]
               │candidates: [2, 3]                            │candidates: [3]
               │excluded: []              ╔══════════════════▷│excluded: [2]
┌3─────────────┴─────────────┐            ║                   │
│ potential_clique: [1, 2]   │            ║    ┌7─────────────┴─────────────┐ 
│ candidates: [3]            │            ║    │ potential_clique: [1, 3]   │
│ excluded: []               │            ║    │ candidates: []   ◁----┬----┼---- only keep nodes that
└──────────────┬─────────────┘            ║    │ excluded: [2]    ◁----┘    │     are neighbours of the candidate
               ┋                          ║    └──────────────┬─────────────┘ 
               ┋ (Skipping                ║                   │
               ┋ Steps from above)        ║                   ▽
               ┋                          ║              No Candidate
╔6═══════════════════════════╗            ║              End of Branch
║ MOVE CURRENT CANDIDATE (2) ║            ║              Back to Step 1 after recursion
║      FROM CANDIDATES       ╠════════════╝      ╔8═══════════════════════════╗ 
║        TO EXCLUDED         ║                   ║ MOVE CURRENT CANDIDATE (1) ║ 
╚════════════════════════════╝                   ║      FROM CANDIDATES       ║
                                                 ║        TO EXCLUDED         ║ 
                                                 ╚════════════════════════════╝
```
* As the branch behind Step `2` is over, we are back to Step `1`
* But now there are new things in the `excluded` set!
```text
MAXIMAL_CLIQUES: [1, 2, 3]

┌1────────────────────────────┐
│ potential_clique: []        │
│ candidates: [1, 2, 3, 4, 5] │
│ excluded: []                │
└──────────────┬──────────────┘   
               ├────────────────────────────────────────────══────┐
               │current_candidate: 1                              │current_candidate: 2
               │potential_clique: []                              │potential_clique: []
               │candidates: [1, 2, 3, 4, 5]                       │candidates: [2, 3, 4, 5]
               │excluded: []                  ╔══════════════════▷│excluded: [1]
┌2─────────────┴─────────────┐                ║                   │
│ potential_clique: [1]      │                ║    ┌9─────────────┴─────────────┐ 
│ candidates: [2, 3]         │                ║    │ potential_clique: [2]      │
│ excluded: []               │                ║    │ candidates: [3]  ◁----┬----┼---- only keep nodes that
└──────────────┬─────────────┘                ║    │ excluded: [1]    ◁----┘    │     are neighbours of the candidate
               ┋                              ║    └──────────────┬─────────────┘ 
               ┋ (Skipping                    ║                   │
               ┋ Steps from above)            ║                   │current_candidate: 3
               ┋                              ║                   │potential_clique: [2]
╔8═══════════════════════════╗                ║                   │candidates: [3]
║ MOVE CURRENT CANDIDATE (1) ║                ║                   │excluded: [1]
║      FROM CANDIDATES       ╠════════════════╝    ┌10────────────┴─────────────┐ 
║        TO EXCLUDED         ║                     │ potential_clique: [3, 2]   │
╚════════════════════════════╝                     │ candidates: []             │
                                                   │ excluded: [1]              │
                                                   └──────────────┬─────────────┘
                                                                  │
                                                                  ▽
                                                             No Candidate
                                                             End of Branch
                                                             Back to Step 1 after recursion
```

And so on, and so forth, until we have checked all the possibilities, and we have found all the maximal cliques of the graph.

Here are all the recursions from above, without the intermediate steps:
```text
                                                   ┌1────────────────────────────┐
                                                   │ potential_clique: []        │
                                                   │ candidates: [1, 2, 3, 4, 5] │
                                                   │ excluded: []                │
                                                   └──────────────┬──────────────┘
                                                                  │
            ┌──────────────────────────┬──────────────────────────┼──────────────────────────┬──────────────────────────┐
            │                          │                          │                          │                          │
┌2──────────┴───────────┐  ┌6──────────┴───────────┐  ┌8──────────┴───────────┐  ┌10─────────┴───────────┐  ╔11═════════┴═══════════╗
│ potential_clique: [1] │  │ potential_clique: [2] │  │ potential_clique: [3] │  │ potential_clique: [4] │  ║ potential_clique: [5] ║
│ candidates: [2, 3]    │  │ candidates: [3]       │  │ candidates: [4]       │  │ candidates: []        │  ║ candidates: []        ║
│ excluded: [0]         │  │ excluded: [1]         │  │ excluded: [1, 2]      │  │ excluded: [3]         │  ║ excluded: []          ║
└───────────┬───────────┘  └───────────┬───────────┘  └───────────┬───────────┘  └───────────────────────┘  ╚═══════════════════════╝
            │                          │                          │
            │                          │                          └────────────────────────────────────────────┐
            │                          └─────────────────────────────────────────┐                             │
            └────────┬──────────────────────────────┐                            │                             │
                     │                              │                            │                             │
        ┌3───────────┴─────────────┐  ┌5────────────┴────────────┐  ┌7───────────┴─────────────┐  ╔9═══════════┴═════════════╗
        │ potential_clique: [1, 2] │  │ potential_clique: [1, 3] │  │ potential_clique: [2, 3] │  ║ potential_clique: [3, 4] ║ 
        │ candidates: [3]          │  │ candidates: []           │  │ candidates: []           │  ║ candidates: []           ║
        │ excluded: []             │  │ excluded: [2]            │  │ excluded: [1]            │  ║ excluded: []             ║
        └────────────┬─────────────┘  └──────────────────────────┘  └──────────────────────────┘  ╚══════════════════════════╝
                     │
                     │
      ╔4═════════════┴══════════════╗
      ║ potential_clique: [1, 2, 3] ║  
      ║ candidates: []              ║   
      ║ excluded: []                ║   
      ╚═════════════════════════════╝
```

#### Ruby Implementation

Considering:
* `@computer_list` is an array of `Computer` objects
* `Computer` objects have a `#network` method that returns an array of `Computer` objects that are connected to the current `Computer` object

```ruby
def bron_kerbosch(candidates:, potential_clique: [], excluded: [], found_cliques: [])
  return found_cliques << potential_clique if candidates.empty? && excluded.empty?
  
  candidates.dup.each do |current_candidate|
    bron_kerbosch(
      potential_clique: potential_clique.union([current_candidate]),
      candidates: candidates.intersection(current_candidate.network),
      excluded: excluded.intersection(current_candidate.network),
      found_cliques:
    )

    candidates.delete(current_candidate)
    excluded << current_candidate
  end
  found_cliques
end

bron_kerbosch(candidates: @computer_list)
```

#### Pivoting the algorithm
* You'll see that my implementation is not exactly the same as the one I described
* I used a `pivot` to optimize the algorithm
* Without going into too much details, it is a way to reduce the number of recursive calls
    * Taking the example from above, finding all cliques for nodes `1` and `4` will automatically find cliques for nodes `2` and `3` as well 
    * We can remove them from the list of candidates for recursion

### After the clique

Once we got the maximal cliques:
* Some of them will be of `size < 3`: discard them 
* Some of them will be of `size == 3`: they are directly part of the solution 
* Some of them will be of `size > 3`: we can make any combination of 3 of those as they are interconnected in a Network to include them in the solution

## Part Two
* There are patterns if you did not know the Bron-Kerbosch algorithm, and you could find the solution without it.
* With the algorithm, though, the problem is already solved: we just want the largest `clique`
