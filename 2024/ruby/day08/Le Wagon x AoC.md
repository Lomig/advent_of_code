# Le Wagon x Advent of Code — Solution Sharing
* The strategy is to take each pair of antennas, and use one of the antenna as a symmetry origin for the other.
* We don't register those symmetric nodes if they are outside of the matrix
* I cut the algorithm in small-ish methods to help not repeating myself in `part 2`
