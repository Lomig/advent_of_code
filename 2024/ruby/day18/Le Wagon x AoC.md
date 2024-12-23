# Le Wagon x Advent of Code — Solution Sharing
## Part One

* Yet again a traveling algorithm. Without weight, this time!
    * As there is no weight, a path should not be revisited, it would automatically be a waste of time!
    * Please check previous solutions to find out a way to do it if needed


You saw me use `Vector` to model coordinates so far; for pedagogical purposes, I will use `Complex` numbers this time.
* For people who skipped math in Highschool, coordinates (`x`, `y`) are represented by a single number: `x` + `i`•`y`
* Turning 90° clockwise is multiplying by `i`
* `(x+iy) + (u+iv) = (x+u) + i(y + v)`

It changes nothing 😊

## Part Two

* Again, a puzzle where pure Brute Force does not work (well in reality it does with a nice trick, but let’s pretend it does not.)
* We need as usual to find strategies to reduce the amount of calculation to execute
    * Do we need to compute a path each fall of a byte? No!
    * The first 1024 are safe, let's start from here.
    * Then each new byte that falls ON the path should make us compute a new path
    * But bytes outside of the path change nothing to it!
* We also need to keep a track of the path we want to travel, in case you just counted steps in `part 1`
