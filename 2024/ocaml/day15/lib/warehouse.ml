(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open CCFun

(*=============================================================================
 * Modules
 *===========================================================================*)

(*-----------------------------------------------------------------------------
 * Coordinates -> Cell Map
 *---------------------------------------------------------------------------*)
module CoordMap = Map.Make (Coordinates)

(*-----------------------------------------------------------------------------
 * Element Module
 *---------------------------------------------------------------------------*)
module Element = struct
  type t =
    | Wall
    | Box
    | LeftCrate
    | RightCrate
    | Robot
  [@@deriving eq]

  let of_char = function
    | '#' -> Ok Wall
    | 'O' -> Ok Box
    | '[' -> Ok LeftCrate
    | ']' -> Ok RightCrate
    | '@' -> Ok Robot
    | c -> Error (Printf.sprintf "Invalid character: %c" c)
  ;;

  let to_char = function
    | Wall -> '#'
    | Box -> 'O'
    | LeftCrate -> '['
    | RightCrate -> ']'
    | Robot -> '@'
  ;;

  let pp fmt t = Format.fprintf fmt "%c" (to_char t)
end

(*-----------------------------------------------------------------------------
 * Cell Module
 *---------------------------------------------------------------------------*)
module Cell = struct
  type t =
    { coord : Coordinates.t
    ; elem : Element.t
    }
  [@@deriving eq]

  let create coord elem = { coord; elem }

  let is_horizontal_sorted c1 c2 =
    Coordinates.equal c1.coord (Coordinates.move Left c2.coord)
  ;;

  let pp fmt { coord; elem } =
    Format.fprintf fmt "{coord=%a; elem=%a}" Coordinates.pp coord Element.pp elem
  ;;
end

(*=============================================================================
 * Type Aliases and Module References
 *===========================================================================*)

type t = Cell.t CoordMap.t
type direction = Coordinates.Direction.t
type cell = Cell.t
type element = Element.t

(*=============================================================================
 * Domain
 *===========================================================================*)

(*-----------------------------------------------------------------------------
 * Element Filtering Functions
 *---------------------------------------------------------------------------*)
let filter_cells_by_elem elem warehouse =
  warehouse
  |> CoordMap.bindings
  |> List.filter_map (fun (_, cell) ->
    if Element.equal Cell.(cell.elem) elem then Some cell else None)
;;

let get_boxes = filter_cells_by_elem Box
let get_crates = filter_cells_by_elem LeftCrate
let get_robot (warehouse : t) = filter_cells_by_elem Robot warehouse |> List.hd

(*-----------------------------------------------------------------------------
 * Chain of Crates Handling Functions
 *---------------------------------------------------------------------------*)
let sort_push_chain direction =
  match (direction : direction) with
  | Up -> List.sort (fun (c1 : cell) (c2 : cell) -> compare (fst c1.coord) (fst c2.coord))
  | Down ->
    List.sort (fun (c1 : cell) (c2 : cell) -> compare (fst c2.coord) (fst c1.coord))
  | Left ->
    List.sort (fun (c1 : cell) (c2 : cell) -> compare (snd c1.coord) (snd c2.coord))
  | Right ->
    List.sort (fun (c1 : cell) (c2 : cell) -> compare (snd c2.coord) (snd c1.coord))
;;

let get_push_chain direction robot warehouse =
  let rec aux acc = function
    | [] -> acc
    | x :: xs ->
      (match CoordMap.get x warehouse with
       | None -> aux acc xs
       | Some cell ->
         let is_at_right_of_cell c = Cell.is_horizontal_sorted cell c in
         let is_at_left_of_cell c = Cell.is_horizontal_sorted c cell in
         (match cell.elem with
          | Wall -> [ cell ]
          | (LeftCrate | RightCrate) as crate ->
            let coords_to_add =
              match (direction : direction), crate with
              | (Left | Right), _ -> [ Coordinates.move direction cell.coord ]
              | _, LeftCrate when not (List.exists is_at_right_of_cell acc) ->
                [ Coordinates.move Right cell.coord
                ; Coordinates.move direction cell.coord
                ]
              | _, RightCrate when not (List.exists is_at_left_of_cell acc) ->
                [ Coordinates.move Left cell.coord
                ; Coordinates.move direction cell.coord
                ]
              | _ -> [ Coordinates.move direction cell.coord ]
            in
            aux (cell :: acc) (coords_to_add @ xs)
          | _ -> aux (cell :: acc) (Coordinates.move direction cell.coord :: xs)))
  in
  aux [] [ Cell.(robot.coord) ] |> List.uniq ~eq:Cell.equal |> sort_push_chain direction
;;

(*-----------------------------------------------------------------------------
 * Warehouse Operation Functions
 *---------------------------------------------------------------------------*)
let move_robot direction warehouse =
  let robot = get_robot warehouse in
  let rec aux w candidates =
    match candidates with
    | [] -> w
    | Cell.{ elem = Wall; _ } :: [] -> warehouse
    | cell :: tail ->
      let next_coord = Coordinates.move direction cell.coord in
      let moved_cell : cell = Cell.create next_coord cell.elem in
      let new_warehouse =
        w |> CoordMap.remove cell.coord |> CoordMap.add next_coord moved_cell
      in
      aux new_warehouse tail
  in
  get_push_chain direction robot warehouse |> aux warehouse
;;

(*=============================================================================
 * Warehouse Initialisation
 *===========================================================================*)
let fold_lines_to_warehouse (warehouse : t) row line : t =
  List.foldi
    (fun w col c ->
      match Element.of_char c with
      | Ok elem ->
        let coord = row, col in
        let cell = Cell.create coord elem in
        CoordMap.add coord cell w
      | Error _ -> w)
    warehouse
    (String.to_list line)
;;

let of_list list = list |> List.foldi fold_lines_to_warehouse CoordMap.empty

let enlarged_line =
  String.to_list
  %> List.fold_left
       (fun acc -> function
         | 'O' -> ']' :: '[' :: acc
         | '@' -> '.' :: '@' :: acc
         | c -> c :: c :: acc)
       []
  %> List.rev
  %> String.of_list
;;

let of_enlarged_list = List.map enlarged_line %> of_list

(*=============================================================================
 * Pretty Printing
 *===========================================================================*)
let pp fmt warehouse =
  let coords = CoordMap.bindings warehouse |> List.map fst in
  let max_x = List.fold_left max 0 (List.map fst coords) in
  let max_y = List.fold_left max 0 (List.map snd coords) in
  let buf = Buffer.create ((max_x + 1) * (max_y + 1)) in
  for x = 0 to max_x do
    for y = 0 to max_y do
      Buffer.add_string buf
      @@
      match CoordMap.find_opt (x, y) warehouse with
      | Some cell ->
        (match Cell.(cell.elem) with
         | Robot -> "\027[31m@\027[0m"
         | Wall -> "\027[34m#\027[0m"
         | elem -> "\027[32m" ^ (String.of_char @@ Element.to_char elem) ^ "\027[0m")
      | None -> "."
    done;
    Buffer.add_char buf '\n'
  done;
  Format.fprintf fmt "%s" (Buffer.contents buf)
;;
