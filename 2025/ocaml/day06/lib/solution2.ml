(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Module Definitions
 *===========================================================================*)
module Operator = struct
  type t =
    | Add
    | Multiply
    | NoOp

  let of_char = function
    | '*' -> Multiply
    | '+' -> Add
    | c -> failwith ("Unknown operator: " ^ Char.to_string c)
  ;;
end

module Expression = struct
  type t =
    { operator : Operator.t
    ; values : int list
    }

  let make = { operator = NoOp; values = [] }

  let compute { operator; values } =
    match operator with
    | NoOp -> failwith "Parsing Error"
    | Add -> List.fold_left ( + ) 0 values
    | Multiply -> List.fold_left ( * ) 1 values
  ;;
end

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let add_to_expression (expression : Expression.t) char_list : Expression.t =
  match List.rev char_list with
  | ('+' as op) :: rest | ('*' as op) :: rest ->
    { operator = Operator.of_char op
    ; values = (rest |> List.rev |> String.of_list |> int_of_string) :: expression.values
    }
  | _ ->
    { expression with
      values = (char_list |> String.of_list |> int_of_string) :: expression.values
    }
;;

let to_expressions matrix =
  let rec aux expressions current_expression = function
    | [] -> current_expression :: expressions
    | x :: xs ->
      let raw_expression = List.filter (fun c -> not @@ Char.equal c ' ') x in
      (match raw_expression with
       | [] -> aux (current_expression :: expressions) Expression.make xs
       | _ -> aux expressions (add_to_expression current_expression raw_expression) xs)
  in
  matrix |> Matrix.to_lists |> aux [] Expression.make
;;

let solution =
  AoC.Input.lines_of_day 6
  |> List.map String.to_list
  |> Matrix.of_lists ~pad:' '
  |> Matrix.rotate_columns ~direction:`LEFT
  |> to_expressions
  |> List.fold_left (fun acc expression -> acc + Expression.compute expression) 0
;;
