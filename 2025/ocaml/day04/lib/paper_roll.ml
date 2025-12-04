(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Utils

(*=============================================================================
 * Domain
 *===========================================================================*)
module Self = struct
  type t = { neighbour_count : int }

  let zero = { neighbour_count = 0 }
  let make = zero
  let equal a b = a.neighbour_count = b.neighbour_count
  let pp fmt roll = Format.fprintf fmt "%d" roll.neighbour_count
end

include Self
module Cell = Cell.Make (Self)
module Warehouse = Grid.Make (Cell)
module Cell_ops = Cell.With_grid (Warehouse)
