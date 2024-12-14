open Containers
open Solution1

let antinode_search_func max_row max_column (a : antenna) (b : antenna) =
  let dx = b.row - a.row
  and dy = b.column - a.column in
  let rec aux acc row column =
    let antinode = { row = row - dx; column = column - dy } in
    match
      antinode.row >= 0
      && antinode.column >= 0
      && antinode.row < max_row
      && antinode.column < max_column
    with
    | true -> aux (Seq.cons antinode acc) antinode.row antinode.column
    | false -> acc
  in
  aux Seq.empty b.row b.column
;;

let solution = find_and_count_antinodes antinode_search_func
