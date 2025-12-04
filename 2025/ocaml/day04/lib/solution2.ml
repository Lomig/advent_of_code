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
let update_neighbour_counts previously_removed warehouse =
  match previously_removed with
  | [] -> Solution1.update_neighbour_counts warehouse
  | _ ->
    List.flat_map
      (fun (cell : Cell.t) -> Cell_ops.neighbours8 warehouse cell)
      previously_removed
    |> List.filter (fun cell ->
      List.exists
        (fun removed_cell -> not (Cell.equal cell removed_cell))
        previously_removed)
    |> List.iter (fun (cell : Cell.t) ->
      match cell with
      | Empty _ -> ()
      | Element { x; y; _ } ->
        let count = List.length @@ Cell_ops.neighbours8 warehouse cell in
        warehouse.(x).(y) <- Cell.update_content { neighbour_count = count } cell);
    warehouse
;;

let remove_paper_rolls warehouse accessible_rolls =
  List.iter
    (fun (cell : Cell.t) ->
       match cell with
       | Empty _ -> ()
       | Element { x; y; _ } -> warehouse.(x).(y) <- Cell.empty)
    accessible_rolls;
  warehouse
;;

let remove_and_count_paper_rolls warehouse =
  let rec aux remove_count previously_removed warehouse =
    let accessible_rolls =
      warehouse
      |> update_neighbour_counts previously_removed
      |> Solution1.get_accessible_rolls
    in
    if List.is_empty accessible_rolls
    then remove_count
    else (
      let warehouse = remove_paper_rolls warehouse accessible_rolls in
      aux (remove_count + List.length accessible_rolls) accessible_rolls warehouse)
  in
  aux 0 [] warehouse
;;

let solution =
  AoC.Input.lines_of_day 4
  |> Solution1.warehouse_from_input
  |> remove_and_count_paper_rolls
;;
