(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)

let regexp = Pcre.regexp {|^([0-9]+)\1+$|}

let is_invalid n =
  let n_string = Int.to_string n in
  Pcre.pmatch ~rex:regexp n_string
;;

let solution =
  AoC.Input.string_of_day 2
  |> Solution1.parse_input
  |> List.fold_left
       (fun acc range ->
          acc + Solution1.add_invalids_in_range ~validity_function:is_invalid range)
       0
;;
