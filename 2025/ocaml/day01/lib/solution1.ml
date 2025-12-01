(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let parse_rotations input =
  let line_to_rotation line : Dial.rotation =
    let direction =
      match line.[0] with
      | 'R' -> Dial.RIGHT
      | 'L' -> Dial.LEFT
      | _ -> failwith "Parsing Error"
    and clicks = line |> String.drop 1 |> int_of_string in
    { direction; clicks }
  in
  List.map line_to_rotation input
;;

let count_zeroes dial rotations =
  let rec count_zeroes' count dial = function
    | [] -> count
    | rotation :: tail ->
      let new_dial = Dial.rotate dial rotation in
      let new_count = if new_dial = 0 then count + 1 else count in
      count_zeroes' new_count new_dial tail
  in
  count_zeroes' 0 dial rotations
;;

let solution = AoC.Input.lines_of_day 1 |> parse_rotations |> count_zeroes 50
