(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers

(*=============================================================================
 * Type
 *===========================================================================*)
type t = int * int [@@deriving eq, ord]

(*=============================================================================
 * Modules
 *===========================================================================*)

(*-----------------------------------------------------------------------------
 * Direction Module
 *---------------------------------------------------------------------------*)
module Direction = struct
  type t =
    | Up
    | Down
    | Left
    | Right

  let of_char c =
    match c with
    | '^' -> Up
    | 'v' -> Down
    | '<' -> Left
    | '>' -> Right
    | c -> failwith (Printf.sprintf "Invalid direction character: '%c'" c)
  ;;

  let to_coordinates = function
    | Up -> -1, 0
    | Down -> 1, 0
    | Left -> 0, -1
    | Right -> 0, 1
  ;;

  let pp fmt = function
    | Up -> Format.fprintf fmt "Up"
    | Down -> Format.fprintf fmt "Down"
    | Left -> Format.fprintf fmt "Left"
    | Right -> Format.fprintf fmt "Right"
  ;;
end

(*=============================================================================
 * Domain
 *===========================================================================*)
let move (direction : Direction.t) ?(steps = 1) ((x, y) : t) : t =
  let dx, dy = Direction.to_coordinates direction in
  x + (dx * steps), y + (dy * steps)
;;

(*=============================================================================
 * Pretty Printing
 *===========================================================================*)
let pp fmt ((x, y) : t) = Format.fprintf fmt "(%d, %d)" x y
