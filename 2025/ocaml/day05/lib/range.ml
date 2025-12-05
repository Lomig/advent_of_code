(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers

(*=============================================================================
 * Type
 *===========================================================================*)
type t = int * int

(*=============================================================================
 * Domain
 *===========================================================================*)
let from_string str =
  match String.split_on_char '-' str with
  | [ first; last ] -> int_of_string first, int_of_string last
  | _ -> failwith "Parsing Error"
;;

let includes (range : t) n = fst range <= n && snd range >= n
let compare (r1 : t) (r2 : t) = Int.compare (fst r1) (fst r2)
let equal (r1 : t) (r2 : t) = fst r1 = fst r2 && snd r1 = snd r2

let compile (r1 : t) (r2 : t) =
  let r1, r2 = if compare r1 r2 <= 0 then r1, r2 else r2, r1 in
  if fst r2 <= snd r1 then [ fst r1, Int.max (snd r1) (snd r2) ] else [ r1; r2 ]
;;

let length (range : t) = snd range - fst range + 1

(*=============================================================================
 * Pretty Printing
 *===========================================================================*)
let pp fmt (range : t) = Format.fprintf fmt "(%d->%d)" (fst range) (snd range)
