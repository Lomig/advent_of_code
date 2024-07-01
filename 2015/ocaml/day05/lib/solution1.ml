open CCFun

let voyel_regexp = Re.Pcre.re "[aeuio]" |> Re.compile
let baddies_regexp = Re.Pcre.re "ab|cd|pq|xy" |> Re.compile

let rec has_twice_char_in_a_row' = function
  | [] | _ :: [] -> false
  | x :: y :: _ when x = y -> true
  | _ :: tail -> has_twice_char_in_a_row' tail
;;

let has_twice_char_in_a_row = String.to_seq %> List.of_seq %> has_twice_char_in_a_row'
let has_3_voyels string = Re.matches voyel_regexp string |> List.length >= 3
let has_no_baddies string = Re.matches baddies_regexp string |> List.length = 0

(* Main Boolean Logic *)
let is_string_nice string =
  has_twice_char_in_a_row string && has_3_voyels string && has_no_baddies string
;;

let solution =
  CCIO.(with_in "../inputs/05_large.txt" read_lines_l)
  |> CCList.find_all is_string_nice
  |> CCList.length
;;
