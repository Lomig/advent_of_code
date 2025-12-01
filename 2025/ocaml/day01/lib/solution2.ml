(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)

let count_zeroes dial rotations =
  let rec count_zeroes' count dial = function
    | [] -> count
    | rotation :: tail ->
      let new_dial, new_count = Dial.rotate_and_count_zero_bearing dial rotation in
      count_zeroes' (count + new_count) new_dial tail
  in
  count_zeroes' 0 dial rotations
;;

let solution = AoC.Input.lines_of_day 1 |> Solution1.parse_rotations |> count_zeroes 50
