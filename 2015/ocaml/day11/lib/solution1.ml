open Containers

type computation =
  | Keep
  | AddOne

let next_password list =
  let rec aux acc carryover list =
    let reset_acc = List.map (fun _ -> 'a') acc in
    match carryover, list with
    | _, [] -> acc
    | AddOne, 'h' :: tail | Keep, 'i' :: tail -> aux ('j' :: reset_acc) Keep tail
    | AddOne, 'k' :: tail | Keep, 'l' :: tail -> aux ('m' :: reset_acc) Keep tail
    | AddOne, 'n' :: tail | Keep, 'o' :: tail -> aux ('p' :: reset_acc) Keep tail
    | AddOne, 'z' :: tail -> aux ('a' :: acc) AddOne tail
    | Keep, head :: tail -> aux (head :: acc) Keep tail
    | AddOne, head :: tail ->
      let next_char =
        match Char.of_int @@ (Char.to_int head + 1) with
        | None -> failwith "error with input"
        | Some c -> c
      in
      aux (next_char :: acc) Keep tail
  in
  aux [] AddOne (List.rev list)
;;

let has_increasing_straight list =
  let rec aux = function
    | [] | _ :: [] | [ _; _ ] -> false
    | x :: y :: z :: _ when y = x + 1 && z = y + 1 -> true
    | _ :: tail -> aux tail
  in
  list |> List.map Char.to_int |> aux
;;

let has_2_pairs list =
  let rec aux pair_count list =
    match pair_count, list with
    | 2, _ -> true
    | _, [] -> false
    | _, [ _ ] -> false
    | _, x :: y :: tail when Char.(x = y) -> aux (pair_count + 1) tail
    | _, _ :: tail -> aux pair_count tail
  in
  aux 0 list
;;

let next_valid_password string =
  let rec aux list =
    let next_list = next_password list in
    match has_increasing_straight next_list && has_2_pairs next_list with
    | true -> String.of_list next_list
    | false -> aux next_list
  in
  string |> String.to_list |> aux
;;

let solution =
  IO.with_in "../inputs/11_large.txt" IO.read_all |> String.trim |> next_valid_password
;;
