(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open CCFun
open Utils

(*=============================================================================
 * Module Definitions
 *===========================================================================*)
module IntMap = CCMap.Make (CCInt)

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let parse_input =
  let rec split_line problems problem_index = function
    | [] -> problems
    | x :: xs ->
      let updated_problems =
        IntMap.update
          problem_index
          (fun problem -> Some (x :: Option.get_or ~default:[] problem))
          problems
      in
      split_line updated_problems (problem_index + 1) xs
  in
  let rec process_lines problems = function
    | [] -> problems |> IntMap.to_list |> List.map snd
    | x :: xs ->
      let line = x |> String.split_on_char ' ' |> List.filter (not % String.is_empty) in
      process_lines (split_line problems 0 line) xs
  in
  process_lines IntMap.empty
;;

let resolve problem =
  match List.hd problem with
  | "+" -> List.tl problem |> List.map int_of_string |> List.fold_left ( + ) 0
  | "*" -> List.tl problem |> List.map int_of_string |> List.fold_left ( * ) 1
  | x -> failwith ("Unknown operator: " ^ x)
;;

let solution =
  AoC.Input.lines_of_day 6
  |> parse_input
  |> List.fold_left (fun acc problem -> acc + resolve problem) 0
;;
