(*=============================================================================
 * Type
 *===========================================================================*)

type t =
  { current_value : int
  ; stops_on_zero : int
  ; bearings_on_zero : int
  }

(*=============================================================================
 * Domain
 *===========================================================================*)
type direction =
  | LEFT
  | RIGHT

type rotation =
  { direction : direction
  ; clicks : int
  }

(*-----------------------------------------------------------------------------
 * Helpers
 *---------------------------------------------------------------------------*)

let modulo100 x =
  let x' = x mod 100 in
  if x' < 0 then x' + 100 else x'
;;

let rotate_value value rotation =
  let delta =
    match rotation.direction with
    | RIGHT -> rotation.clicks
    | LEFT -> -rotation.clicks
  in
  modulo100 (value + delta)
;;

let count_stops_on_zero dial = function
  | 0 -> dial.stops_on_zero + 1
  | _ -> dial.stops_on_zero
;;

let count_bearings_on_zero dial rotation =
  match rotation.direction with
  | RIGHT -> dial.bearings_on_zero + ((dial.current_value + rotation.clicks) / 100)
  | LEFT ->
    let full_revolutions = rotation.clicks / 100
    and remaining_clicks = rotation.clicks mod 100 in
    let remaining_bearings =
      if dial.current_value <> 0 && dial.current_value - remaining_clicks <= 0
      then 1
      else 0
    in
    dial.bearings_on_zero + full_revolutions + remaining_bearings
;;

(*-----------------------------------------------------------------------------
 * Public functions
 *---------------------------------------------------------------------------*)

let new_dial = { current_value = 50; stops_on_zero = 0; bearings_on_zero = 0 }

let rotate dial rotation =
  let new_value = rotate_value dial.current_value rotation in
  let stops_on_zero = count_stops_on_zero dial new_value in
  let bearings_on_zero = count_bearings_on_zero dial rotation in
  { current_value = new_value; stops_on_zero; bearings_on_zero }
;;

let apply_rotations ?(dial = new_dial) rotations = List.fold_left rotate dial rotations
let stops_on_zero dial = dial.stops_on_zero
let bearings_on_zero dial = dial.bearings_on_zero
