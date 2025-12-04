(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Type Aliases and Module References
 *===========================================================================*)
module Warehouse = Paper_roll.Warehouse
module Cell = Paper_roll.Cell
module Cell_ops = Paper_roll.Cell_ops

(*=============================================================================
 * Main Solution
 *===========================================================================*)

let warehouse_from_input input =
  let char_matrix = Seq.to_array @@ List.to_seq @@ List.map String.to_array input in
  let rows = Array.length char_matrix
  and cols = Array.length char_matrix.(0) in
  Warehouse.init rows cols (fun i j ->
    match char_matrix.(i).(j) with
    | '.' -> Cell.empty
    | _ -> Cell.make ~x:i ~y:j Paper_roll.make)
;;

let update_neighbour_counts warehouse =
  Warehouse.iter
    (fun (cell : Cell.t) ->
       match cell with
       | Empty _ -> ()
       | Element { x; y; _ } ->
         let count = List.length @@ Cell_ops.neighbours8 warehouse cell in
         warehouse.(x).(y) <- Cell.update_content { neighbour_count = count } cell)
    warehouse;
  warehouse
;;

let get_accessible_rolls warehouse =
  Warehouse.fold
    (fun acc (cell : Cell.t) ->
       match cell with
       | Empty _ -> acc
       | Element { content; _ } ->
         if content.neighbour_count < 4 then cell :: acc else acc)
    []
    warehouse
;;

let solution =
  AoC.Input.lines_of_day 4
  |> warehouse_from_input
  |> update_neighbour_counts
  |> get_accessible_rolls
  |> List.length
;;
