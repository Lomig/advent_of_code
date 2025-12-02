(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)

let int_of_char_list chars = chars |> Seq.of_list |> String.of_seq |> int_of_string

let parse_input input =
  let rec aux ranges left right is_filling_left chars =
    match chars, is_filling_left with
    | [], _ ->
      let new_range = int_of_char_list left, int_of_char_list right in
      new_range :: ranges
    | ',' :: tail, _ ->
      let new_range = int_of_char_list left, int_of_char_list right in
      aux (new_range :: ranges) [] [] false tail
    | '-' :: tail, _ -> aux ranges left right true tail
    | c :: tail, false -> aux ranges left (c :: right) false tail
    | c :: tail, true -> aux ranges (c :: left) right true tail
  in
  input |> String.to_list |> List.rev |> aux [] [] [] false
;;

let is_invalid n =
  let n_string = Int.to_string n in
  let length = String.length n_string in
  if length mod 2 = 1
  then false
  else (
    let mid = length / 2 in
    let x = String.sub n_string 0 mid
    and y = String.sub n_string mid mid in
    String.(x = y))
;;

let add_invalids_in_range ~validity_function range =
  List.range (fst range) (snd range)
  |> List.fold_left (fun acc n -> if validity_function n then acc + n else acc) 0
;;

let solution =
  AoC.Input.string_of_day 2
  |> parse_input
  |> List.fold_left
       (fun acc range -> acc + add_invalids_in_range ~validity_function:is_invalid range)
       0
;;
