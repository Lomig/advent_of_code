(*=============================================================================
 * Type
 *===========================================================================*)

type t = int

(*=============================================================================
 * Domain
 *===========================================================================*)
type direction =
  | LEFT
  | RIGHT

let string_of_direction = function
  | LEFT -> "left"
  | RIGHT -> "right"
;;

type rotation =
  { direction : direction
  ; clicks : int
  }

let rotate (dial : t) rotation =
  match rotation with
  | { direction = RIGHT; clicks = c } -> (dial + c) mod 100
  | { direction = LEFT; clicks = c } ->
    let remainder = (dial - c) mod 100 in
    if remainder < 0 then remainder + 100 else remainder
;;

let rotate_and_count_zero_bearing (dial : t) rotation =
  let next_dial = rotate dial rotation
  and bearings =
    match rotation.direction with
    | RIGHT -> (dial + rotation.clicks) / 100
    | LEFT ->
      let full_revolutions = rotation.clicks / 100
      and remainding_clicks = rotation.clicks mod 100 in
      let remainding_bearings =
        if dial <> 0 && dial - remainding_clicks <= 0 then 1 else 0
      in
      full_revolutions + remainding_bearings
  in
  next_dial, bearings
;;
