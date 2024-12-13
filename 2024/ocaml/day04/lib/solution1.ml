open Containers

let transpose matrix =
  let rec aux acc = function
    | [] -> acc
    | [] :: xss -> aux acc xss
    | (x :: xs) :: xss ->
      let head = List.map List.hd xss in
      let tail = List.map List.tl xss in
      aux ((x :: head) :: acc) (xs :: tail)
  in
  aux [] matrix
;;

let zip_with_padding matrix padding_array =
  List.map2 (fun pad row -> pad @ row) padding_array matrix
  |> List.map2 (fun pad_rev row -> List.append row pad_rev) (List.rev padding_array)
;;

let downward_diagonals matrix =
  let padding_array =
    List.init (List.length matrix) (fun i -> List.init i (fun _ -> '.'))
  in
  transpose @@ zip_with_padding matrix padding_array
;;

let upward_diagonals matrix =
  let padding_array =
    List.init (List.length matrix) (fun i -> List.init i (fun _ -> '.'))
  in
  transpose @@ zip_with_padding matrix (List.rev padding_array)
;;

let count_xmas list =
  let rec aux acc = function
    | [] -> acc
    | 'X' :: 'M' :: 'A' :: 'S' :: tail -> aux (acc + 1) ('S' :: tail)
    | 'S' :: 'A' :: 'M' :: 'X' :: tail -> aux (acc + 1) ('X' :: tail)
    | _ :: tail -> aux acc tail
  in
  aux 0 list
;;

let solution =
  let input =
    IO.with_in "../_inputs/04.txt" IO.read_lines_l
    |> List.map String.to_seq
    |> List.map List.of_seq
  in
  List.fold_left (fun acc l -> acc + count_xmas l) 0 input
  + List.fold_left (fun acc l -> acc + count_xmas l) 0 (transpose input)
  + List.fold_left (fun acc l -> acc + count_xmas l) 0 (downward_diagonals input)
  + List.fold_left (fun acc l -> acc + count_xmas l) 0 (upward_diagonals input)
;;
