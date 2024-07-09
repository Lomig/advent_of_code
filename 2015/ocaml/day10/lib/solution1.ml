open Containers

let reverse_list_of_chars count char list =
  let rec aux acc list =
    match list with
    | [] -> char :: acc
    | head :: tail -> aux (head :: acc) tail
  in
  aux list (count |> string_of_int |> String.to_list)
;;

let look_and_say str =
  let length = String.length str in
  let rec aux acc char_index last_char count =
    match char_index, last_char with
    | index, _ when index = length ->
      List.rev @@ reverse_list_of_chars count last_char acc |> String.of_list
    | _, c when Char.(c = str.[char_index]) ->
      aux acc (char_index + 1) last_char (count + 1)
    | _ ->
      aux (reverse_list_of_chars count last_char acc) (char_index + 1) str.[char_index] 1
  in
  match length with
  | 0 -> ""
  | _ -> aux [] 1 str.[0] 1
;;

let repeat_look_and_say times string =
  let rec aux times string =
    match times with
    | 0 -> string
    | n -> aux (n - 1) (look_and_say string)
  in
  aux times string
;;

let solution =
  IO.with_in "../inputs/10_large.txt" IO.read_all
  |> String.rtrim
  |> repeat_look_and_say 40
  |> String.length
;;
