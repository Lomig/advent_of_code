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

let solution =
  AoC.Input.lines_of_day 1
  |> parse_rotations
  |> Dial.apply_rotations
  |> Dial.stops_on_zero
;;
