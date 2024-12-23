# Le Wagon x Advent of Code — Solution Sharing
### Graph Traversal
This is the day we build upon [Day 7's Idea](../day07/Le%20Wagon%20x%20AoC.md) and take a tour of Graph Traversal yet again.
I won't explain what / how it is done again, so follow the link 😅


### States and Paths
If you remember, this is the hard task we set on ourself when talking about this process. What is the state I want to travel, and following which path?
Calling each point on the map a node:
* Nodes have neighbours: the link between neighbours is the path we seek; we only want to explore accessible nodes though.
* Nodes have an height: this is the only state that matters!

### Algorithm
Pretty straightforward then:
* Create those nodes for each of the input heights
* Take the nodes with height 0
* For each of those trailhead, traverse the graph up to a node with height 9
* Count those heights


`part 2` is just `part 1` with a Set instead of an Array to store the nodes we already visited.
