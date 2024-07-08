open Solution1

let rec solution2_count_invisible_characters total chars =
  match chars with
  | [] -> total
  | '"' :: tail -> solution2_count_invisible_characters (total + 2) tail
  | '\\' :: '"' :: tail | '\\' :: '\\' :: tail ->
    solution2_count_invisible_characters (total + 2) tail
  | '\\' :: 'x' :: a :: b :: tail when is_hexa a && is_hexa b ->
    solution2_count_invisible_characters (total + 1) tail
  | _ :: tail -> solution2_count_invisible_characters total tail
;;

let solution = solution' solution2_count_invisible_characters
