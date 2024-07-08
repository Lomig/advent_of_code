open Containers

let is_hexa char =
  let open Char in
  (char >= '0' && char <= '9')
  || (char >= 'A' && char <= 'F')
  || (char >= 'a' && char <= 'f')
;;

let count_invisible_characters count_fun string = string |> String.to_list |> count_fun 0

let solution' count_fun =
  IO.with_in "../inputs/08_large.txt" IO.read_lines_l
  |> List.fold_left
       (fun acc string -> acc + count_invisible_characters count_fun string)
       0
;;

let rec solution1_count_invisible_characters total chars =
  match chars with
  | [] -> total
  | '"' :: tail | '\\' :: '"' :: tail | '\\' :: '\\' :: tail ->
    solution1_count_invisible_characters (total + 1) tail
  | '\\' :: 'x' :: a :: b :: tail when is_hexa a && is_hexa b ->
    solution1_count_invisible_characters (total + 3) tail
  | _ :: tail -> solution1_count_invisible_characters total tail
;;

let solution = solution' solution1_count_invisible_characters
