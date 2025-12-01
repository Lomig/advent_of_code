type t

type direction =
  | LEFT
  | RIGHT

type rotation =
  { direction : direction
  ; clicks : int
  }

val new_dial : t
val rotate : t -> rotation -> t
val apply_rotations : ?dial:t -> rotation list -> t
val stops_on_zero : t -> int
val bearings_on_zero : t -> int
