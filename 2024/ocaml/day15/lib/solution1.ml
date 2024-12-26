(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Type Aliases and Module References
 *===========================================================================*)
module Direction = Coordinates.Direction

type cell = Warehouse.Cell.t

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let coord_to_gps coord = (100 * fst coord) + snd coord

let parse_warehouse_and_moves ~warehouse_builder input =
  let warehouse = input |> List.hd |> String.split_on_char '\n' |> warehouse_builder
  and moves =
    input
    |> List.tl
    |> List.hd
    |> String.replace ~sub:"\n" ~by:""
    |> String.to_list
    |> List.map Direction.of_char
  in
  warehouse, moves
;;

let move_crates_around_warehouse ~warehouse_builder ~box_retriever =
  AoC.Input.string_of_day 15
  |> String.split ~by:"\n\n"
  |> parse_warehouse_and_moves ~warehouse_builder
  |> Fun.uncurry (List.fold_left (fun w move -> Warehouse.move_robot move w))
  |> box_retriever
  |> List.fold_left (fun sum (box : cell) -> sum + coord_to_gps box.coord) 0
;;

let solution =
  move_crates_around_warehouse
    ~warehouse_builder:Warehouse.of_list
    ~box_retriever:Warehouse.get_boxes
;;
