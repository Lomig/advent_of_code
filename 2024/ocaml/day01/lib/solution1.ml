open Containers

let input = IO.with_in "../_inputs/01.txt" IO.read_all
let string_to_lines = String.split_on_char '\n'

let split_string str =
  List.flat_map (String.split_on_char ' ') str
  |> List.filter (fun str -> String.length str > 0)
;;

let parse_input = input |> string_to_lines |> split_string |> List.map int_of_string

let split_list list =
  let rec split_list' list (sublist1, sublist2) alt =
    match list with
    | [] -> List.sort compare sublist1, List.sort compare sublist2
    | x :: xs when alt = 0 -> split_list' xs (x :: sublist1, sublist2) 1
    | x :: xs -> split_list' xs (sublist1, x :: sublist2) 0
  in
  split_list' list ([], []) 0
;;

let distance (l1, l2) = List.fold_left2 (fun acc a b -> acc + abs (a - b)) 0 l1 l2
let solution = parse_input |> split_list |> distance
