open Containers

module type ELEMENT = sig
  type t

  val x : t -> int
  val y : t -> int
  val with_coords : int -> int -> t -> t
  val empty : t
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
end

module Make (E : ELEMENT) = struct
  type element = E.t
  type t = element array array

  let dimensions (m : t) =
    match Array.length m with
    | 0 -> 0, 0
    | rows ->
      let cols = Array.length m.(0) in
      rows, cols
  ;;

  let make ?(init = E.empty) rows cols : t =
    match rows < 0 || cols < 0 with
    | true -> invalid_arg "Matrix.make: negative dimension"
    | false ->
      Array.init rows (fun i -> Array.init cols (fun j -> E.with_coords i j init))
  ;;

  let init rows cols (f : int -> int -> element) : t =
    match rows < 0 || cols < 0 with
    | true -> invalid_arg "Matrix.init: negative dimension"
    | false ->
      Array.init rows (fun i -> Array.init cols (fun j -> E.with_coords i j (f i j)))
  ;;

  let are_in_bounds (m : t) i j =
    let rows, cols = dimensions m in
    0 <= i && i < rows && 0 <= j && j < cols
  ;;

  let get (m : t) i j =
    match are_in_bounds m i j with
    | false -> None
    | true -> Some m.(i).(j)
  ;;

  let ( .%() ) m (i, j) = get m i j

  let set (m : t) i j element =
    match are_in_bounds m i j with
    | false -> invalid_arg "Matrix.get: index out of bounds"
    | true -> m.(i).(j) <- element
  ;;

  let ( .%()<- ) m (i, j) element = set m i j element
  let map (f : element -> element) (m : t) = Array.map (fun row -> Array.map f row) m

  let mapi (f : int -> int -> element -> element) (m : t) =
    Array.mapi (fun i row -> Array.mapi (fun j x -> f i j x) row) m
  ;;

  let iter (f : element -> unit) (m : t) = Array.iter (fun row -> Array.iter f row) m

  let iteri (f : int -> int -> element -> unit) (m : t) =
    Array.iteri (fun i row -> Array.iteri (fun j x -> f i j x) row) m
  ;;

  let fold (f : 'a -> element -> 'a) (init : 'a) (m : t) =
    Array.fold_left (fun acc row -> Array.fold_left f acc row) init m
  ;;

  let transpose (m : t) =
    match dimensions m with
    | 0, cols | _, (0 as cols) -> Array.make cols [||]
    | rows, cols -> init cols rows (fun i j -> m.(j).(i))
  ;;

  let generic_all_neighbours (m : t) i j =
    let rows, cols = dimensions m in
    let top = Int.max 0 (i - 1)
    and right = Int.min (cols - 1) (j + 1)
    and bottom = Int.min (rows - 1) (i + 1)
    and left = Int.max 0 (j - 1) in
    List.fold_left
      (fun acc i' ->
         List.fold_left
           (fun acc j' -> if i' = i && j' = j then acc else m.(i').(j') :: acc)
           acc
           (List.range left right))
      []
      (List.range top bottom)
  ;;
end
