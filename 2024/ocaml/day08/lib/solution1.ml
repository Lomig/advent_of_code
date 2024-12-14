open Containers

type antenna =
  { column : int
  ; row : int
  ; frequency : char
  }
[@@deriving eq]

type antinode =
  { column : int
  ; row : int
  }
[@@deriving eq, ord]

let antennas_from_string row line =
  let chars = line |> String.to_seq |> List.of_seq in
  let rec aux acc column = function
    | [] -> acc
    | '.' :: xs -> aux acc (column + 1) xs
    | x :: xs ->
      let antenna = { column; row; frequency = x } in
      aux (antenna :: acc) (column + 1) xs
  in
  aux [] 0 chars
;;

let combinations list =
  Seq.flat_map
    (fun x ->
      Seq.fold_left
        (fun acc y -> if equal_antenna x y then acc else Seq.cons (x, y) acc)
        Seq.empty
        list)
    list
;;

let find_antinodes f max_row max_column list =
  combinations list
  |> Seq.map (fun ((a, b) : antenna * antenna) -> f max_row max_column a b)
;;

let find_and_count_antinodes antinode_search_func =
  let input = IO.with_in "../_inputs/08.txt" IO.read_lines_l in
  let max_row = List.length input in
  let max_column = String.length @@ List.hd input in
  List.flat_map_i (fun row line -> antennas_from_string row line) input
  |> Seq.of_list
  |> Seq.sort ~cmp:(fun a1 a2 -> Char.compare a1.frequency a2.frequency)
  |> Seq.group (fun a1 a2 -> Char.(a1.frequency = a2.frequency))
  |> Seq.flat_map (fun antinodes ->
    find_antinodes antinode_search_func max_row max_column antinodes)
  |> Seq.flatten
  |> Seq.sort_uniq ~cmp:(fun a1 a2 -> compare_antinode a1 a2)
  |> Seq.length
;;

let antinode_search_func max_row max_column (a : antenna) (b : antenna) =
  let dx = b.row - a.row
  and dy = b.column - a.column in
  let antinode = { row = a.row - dx; column = a.column - dy } in
  match
    antinode.row >= 0
    && antinode.column >= 0
    && antinode.row < max_row
    && antinode.column < max_column
  with
  | true -> Seq.cons antinode Seq.empty
  | false -> Seq.empty
;;

let solution = find_and_count_antinodes antinode_search_func
