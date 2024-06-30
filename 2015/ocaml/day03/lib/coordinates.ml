type coordinates = int * int

module Coordinates = struct
  type t = coordinates

  let compare ((x0, y0) : coordinates) ((x1, y1) : coordinates) =
    match CCInt.compare x0 x1 with
    | 0 -> CCInt.compare y0 y1
    | c -> c
  ;;

  let move direction ((x, y) : coordinates) : coordinates =
    match direction with
    | '^' -> x, y + 1
    | 'v' -> x, y - 1
    | '<' -> x - 1, y
    | '>' -> x + 1, y
    | _ -> x, y
  ;;
end
