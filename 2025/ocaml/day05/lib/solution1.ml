(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let parse_input input =
  let rec aux fresh_ranges inventory now_checking_inventory = function
    | [] -> fresh_ranges, inventory
    | "" :: xs -> aux fresh_ranges inventory true xs
    | x :: xs ->
      if now_checking_inventory
      then aux fresh_ranges (int_of_string x :: inventory) true xs
      else aux (Range.from_string x :: fresh_ranges) inventory false xs
  in
  aux [] [] false input
;;

let solution =
  let fresh_ranges, inventory = AoC.Input.lines_of_day 5 |> parse_input in
  List.filter
    (fun id -> List.exists (fun range -> Range.includes range id) fresh_ranges)
    inventory
  |> List.length
;;
