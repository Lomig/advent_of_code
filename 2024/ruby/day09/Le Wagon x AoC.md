# Le Wagon x Advent of Code — Solution Sharing
## Part One
### Strategy

There are a lot of naive ways to implement the first part. Here, the algorithm is as followed:
* First create the "decompressed" representation of your disk as an array
* Take the size of the data it contains for future use
```ruby
disk == [0, ".", ".", 1, 1, 1, ".", ".", ".", ".", 2, 2, 2, 2, 2]
data_size = 9
```
* We want to iterate through those elements, but as we will mutate them while doing so, including its size, I'll use a `while` loop:
    * In reality we could have used iterators — For pedagogical reasons, I want to show that if unsure, we don't have to shy away from standard loops! Mutating the array we are iterating on is always a warning signal though.
    * While we are not at the last element
        * Don't do anything if there is some data here
        * If there is not, take and remove the last element of the disk that is some data
        * Put this data were the free_space was
    * Once it's done, some leftover data and free space will exist at the end of the disk: only take the first meaningful elements thanks to the data size
    * Compute the checksum

### Methods and Syntax
* `#each_slice` will take elements 2 by 2 during an iteration
* `[:a, :b] * 3` will be evaluated as `[:a, :b, :a, :b, :a, :b]`
* As discussed previously, we can create quite a chain of iterators! `.chars.each_slice(2).with_index.reduce([])`

## Part Two
The algorithm is not that hard, but it has lots of steps to take into account.
* First group each id by the number of time it should appear, to check easily if it "fits" inside a free space
    * Hint: Hashes are oriented in Ruby, so I reverted the data before creating the hash to first iterate on the largest values, as they should be moved before the others per the puzzle specs.
```ruby
data_stream = {9=>2, 8=>4, 7=>3, 6=>4, 5=>4, 4=>2, 3=>3, 2=>1, 1=>3, 0=>2}
```
* Then we organise the data to create chunks, cluster of data.
```ruby
chunks = [
  [ 0, 0 ],
  [ ".", ".", "." ],
  [ 1, 1, 1 ],
  [ ".", ".", "." ],
  [ 2 ],
  [ ".", ".", "." ],
  [ 3, 3, 3 ],
  [ "." ],
  [ 4, 4 ],
  # ...
]
```
* And we just iterate on each chunk
    * If there is some data, and we did not sort this data yet, we append it to the defragmented disk
    * If the data is already sorted, we overwrite free space on it before going on
    * If it is free space, we check the size, and we take the first data from the datastream that would fit
        * It's a loop too!
    * If nothing would fit, we keep the free space

### Methods and Syntax
* `#chunk` is an iterator that will split an Array according to the result of the block. As it is an iterator, it is mostly used chained with another one, and gives for each element 2 argument in the block:
    * The result of its own block
    * The array of element that matches
```ruby
[1, 3, 4, 5, 7, 9, 6, 8, 9].chunk(&:even?).each { |result, elements| puts "#{result}: #{elements.inspect}" }
# false: [1, 3]]
# true: [4]
# false: [5, 7, 9]
# true: [6, 8]
# false: [9]
```
