open Containers

let count_crosses (l1, l2, l3) =
  let rec aux acc = function
    | [], [], [] -> acc
    | 'S' :: x :: 'M' :: xs, _ :: 'A' :: y :: ys, 'S' :: z :: 'M' :: zs ->
      aux (acc + 1) (x :: 'M' :: xs, 'A' :: y :: ys, z :: 'M' :: zs)
    | 'M' :: x :: 'S' :: xs, _ :: 'A' :: y :: ys, 'M' :: z :: 'S' :: zs ->
      aux (acc + 1) (x :: 'S' :: xs, 'A' :: y :: ys, z :: 'S' :: zs)
    | 'M' :: x :: 'M' :: xs, _ :: 'A' :: y :: ys, 'S' :: z :: 'S' :: zs ->
      aux (acc + 1) (x :: 'M' :: xs, 'A' :: y :: ys, z :: 'S' :: zs)
    | 'S' :: x :: 'S' :: xs, _ :: 'A' :: y :: ys, 'M' :: z :: 'M' :: zs ->
      aux (acc + 1) (x :: 'S' :: xs, 'A' :: y :: ys, z :: 'M' :: zs)
    | _ :: xs, _ :: ys, _ :: zs -> aux acc (xs, ys, zs)
    | _ -> acc
  in
  aux 0 (l1, l2, l3)
;;

let count_xmas matrix =
  let rec aux acc = function
    | [] | _ :: [] | [ _; _ ] -> acc
    | x :: xs :: xss :: tail -> aux (acc + count_crosses (x, xs, xss)) (xs :: xss :: tail)
  in
  aux 0 matrix
;;

let solution =
  IO.with_in "../_inputs/04.txt" IO.read_lines_l
  |> List.map String.to_seq
  |> List.map List.of_seq
  |> count_xmas
;;
