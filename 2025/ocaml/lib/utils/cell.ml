open Containers

module type CONTENT = sig
  type t

  val zero : t
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
end

module Make (C : CONTENT) = struct
  type content = C.t

  type t =
    | Empty of
        { x : int
        ; y : int
        }
    | Element of
        { x : int
        ; y : int
        ; content : content
        }

  (*=============================================================================
   * Domain
   *===========================================================================*)
  let make ~x ~y content = Element { x; y; content }
  let empty = Empty { x = 0; y = 0 }

  let update_content content = function
    | Empty _ as cell -> cell
    | Element { x; y; _ } -> Element { x; y; content }
  ;;

  let x = function
    | Empty { x; _ } -> x
    | Element { x; _ } -> x
  ;;

  let y = function
    | Empty { y; _ } -> y
    | Element { y; _ } -> y
  ;;

  let with_coords x y = function
    | Empty _ -> Empty { x; y }
    | Element { content; _ } -> Element { x; y; content }
  ;;

  let equal a b =
    match a, b with
    | Empty a', Empty b' -> a'.x = b'.x && a'.y = b'.y
    | Element a', Element b' -> a'.x = b'.x && a'.y = b'.y
    | _ -> false
  ;;

  let equal_by_content a b =
    match a, b with
    | Element a', Element b' -> C.equal a'.content b'.content
    | Empty _, Empty _ -> true
    | _ -> false
  ;;

  (*=============================================================================
   * Pretty Printing
   *===========================================================================*)
  let pp fmt = function
    | Empty { x; y } -> Format.fprintf fmt "[%d,%d]" x y
    | Element { x; y; _ } -> Format.fprintf fmt "[%d,%d]" x y
  ;;

  let pp_with_content fmt = function
    | Empty { x; y } -> Format.fprintf fmt "[%d,%d]: ." x y
    | Element { x; y; content } -> Format.fprintf fmt "[%d,%d]: %a" x y C.pp content
  ;;

  (*=============================================================================
   * Modules
   *===========================================================================*)

  (*-----------------------------------------------------------------------------
   * Grid-Related Operation Module
   *---------------------------------------------------------------------------*)
  module type GRID = sig
    type t
    type element

    val get : t -> int -> int -> element option
  end

  module With_grid (G : GRID with type element = t) = struct
    let up grid c = G.get grid (x c - 1) (y c)
    let down grid c = G.get grid (x c + 1) (y c)
    let left grid c = G.get grid (x c) (y c - 1)
    let right grid c = G.get grid (x c) (y c + 1)
    let up_left grid c = G.get grid (x c - 1) (y c - 1)
    let up_right grid c = G.get grid (x c - 1) (y c + 1)
    let down_left grid c = G.get grid (x c + 1) (y c - 1)
    let down_right grid c = G.get grid (x c + 1) (y c + 1)

    let keep_only_elements = function
      | Some (Element _) as e -> e
      | _ -> None
    ;;

    let neighbours4 grid c =
      [ up; down; left; right ]
      |> List.filter_map (fun x -> x grid c |> keep_only_elements)
    ;;

    let neighbours8 grid c =
      [ up; down; left; right; up_left; up_right; down_left; down_right ]
      |> List.filter_map (fun x -> x grid c |> keep_only_elements)
    ;;
  end
end
