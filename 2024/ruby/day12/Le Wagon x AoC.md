# Le Wagon x Advent of Code — Solution Sharing
## Part One
Let's go for an OOPed solution
* A `Crop` has a position and a kind
* A `Crop` hash neighbours, some of them being part of the same `Region` (see below)
* A `Crop` has also a perimeter: It's the number of sides (4) minus the number of regional neighbours
* A `Region` has many `Crops`
* A `Region` has an area: the number of `Crops`
* A `Region` has a perimeter: the sum of perimeters of his `Crops`

From there, nothing fancy.
* To get all `Crops` for a given `Region`, we do a Graph Traversal (again!) from a specific `Crop`, the path being from regional neighbours to regional neighbours.

## Part Two

* The number of sides of a polygon is always equal to the number of corners
* Convex corners exists in 3 different cases on our field
  * If a `Crop` is surrounded by `0` other crop of the same type, it has `4 corners`
  * If a `Crop` is surrounded by `1` other crop of the same type, it has `2 corners`
  * If a `Crop` is surrounded by `2` other crops of the same type **_and_** they are not aligned, it has `1 corner`
* Concave corners exist when considering 2 neighbours of the same type of a `Crop`, they share a neighbour of a different type.
  * In this example, `C` is my `Crop`, and `A` represent this special neighbour:
```text
CCCCCCC
CCCCABB
CCCCBBB
```
