(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let int_of_char c = Char.code c - Char.code '0'

let int_of_little_endian_int_list l =
  l |> List.rev_map string_of_int |> String.concat "" |> int_of_string
;;

let best_battery_head battery_size bank =
  let rec aux best best_bank battery_size = function
    | [] -> best, best_bank
    | bank when List.length bank < battery_size -> best, best_bank
    | x :: xs when x <= best -> aux best best_bank battery_size xs
    | x :: xs -> aux x xs battery_size xs
  in
  aux 0 [] battery_size bank
;;

let best_joltage battery_size bank =
  let rec aux step batteries bank =
    if step = battery_size
    then int_of_little_endian_int_list batteries
    else (
      let next_best, next_bank = best_battery_head (battery_size - step) bank in
      aux (step + 1) (next_best :: batteries) next_bank)
  in
  aux 0 [] bank
;;

let sum_joltages battery_size acc bank =
  acc + (bank |> String.to_list |> List.map int_of_char |> best_joltage battery_size)
;;

let solution = AoC.Input.lines_of_day 3 |> List.fold_left (sum_joltages 2) 0
