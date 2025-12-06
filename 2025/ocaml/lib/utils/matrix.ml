open Containers

type 'a t = 'a array array

let dimensions (m : 'a t) =
  match Array.length m with
  | 0 -> 0, 0
  | rows ->
    let cols = Array.length m.(0) in
    rows, cols
;;

(*=============================================================================
 * Constructors
 *===========================================================================*)
let make ~init rows cols : 'a t =
  match rows < 0 || cols < 0 with
  | true -> invalid_arg "Matrix.make: negative dimension"
  | false -> Array.make_matrix rows cols init
;;

let init rows cols (f : int -> int -> 'a) : 'a t =
  match rows < 0 || cols < 0 with
  | true -> invalid_arg "Matrix.init: negative dimension"
  | false -> Array.init rows (fun i -> Array.init cols (fun j -> f i j))
;;

let of_lists ~pad list : 'a t =
  let cols = List.fold_left (fun acc row -> max acc (List.length row)) 0 list in
  let pad_row row =
    let len = List.length row in
    if len < cols then row @ List.init (cols - len) (fun _ -> pad) else row
  in
  Array.of_list (List.map (fun row -> Array.of_list (pad_row row)) list)
;;

(*=============================================================================
 * Domain Functions
 *===========================================================================*)

let to_lists (m : 'a t) = m |> Array.map Array.to_list |> Array.to_list

let are_in_bounds (m : 'a t) i j =
  let rows, cols = dimensions m in
  0 <= i && i < rows && 0 <= j && j < cols
;;

let get (m : 'a t) i j =
  match are_in_bounds m i j with
  | false -> None
  | true -> Some m.(i).(j)
;;

let set (m : 'a t) i j element =
  match are_in_bounds m i j with
  | false -> invalid_arg "Matrix.get: index out of bounds"
  | true -> m.(i).(j) <- element
;;

let map (f : 'a -> 'a) (m : 'a t) = Array.map (fun row -> Array.map f row) m

let mapi (f : int -> int -> 'a -> 'a) (m : 'a t) =
  Array.mapi (fun i row -> Array.mapi (fun j x -> f i j x) row) m
;;

let iter (f : 'a -> unit) (m : 'a t) = Array.iter (fun row -> Array.iter f row) m

let iteri (f : int -> int -> 'a -> unit) (m : 'a t) =
  Array.iteri (fun i row -> Array.iteri (fun j x -> f i j x) row) m
;;

let fold (f : 'a -> 'a -> 'a) (init : 'a) (m : 'a t) =
  Array.fold_left (fun acc row -> Array.fold_left f acc row) init m
;;

let transpose (m : 'a t) =
  match dimensions m with
  | 0, cols | _, (0 as cols) -> Array.make cols [||]
  | rows, cols -> init cols rows (fun i j -> m.(j).(i))
;;

let rotate ~(direction : [ `LEFT | `RIGHT ]) (m : 'a t) =
  match direction with
  | `LEFT -> m |> transpose |> Array.map Array.rev
  | `RIGHT -> m |> transpose |> Array.rev
;;

let rotate_columns ~(direction : [ `LEFT | `RIGHT ]) (m : 'a t) : 'a t =
  let rows, cols = dimensions m in
  Array.init cols (fun col_index ->
    Array.init rows (fun row_index ->
      match direction with
      | `RIGHT -> m.(rows - 1 - row_index).(col_index)
      | `LEFT -> m.(row_index).(cols - 1 - col_index)))
;;
