open CCFun

let rec has_pair_of_specific_chars char1 char2 chars =
  match chars with
  | [] | _ :: [] -> false
  | x :: tail when x <> char1 -> has_pair_of_specific_chars char1 char2 tail
  | _ :: x :: tail when x <> char2 -> has_pair_of_specific_chars char1 char2 (x :: tail)
  | _ -> true
;;

let rec has_pair_of_two_letters' = function
  | [] | _ :: [] | [ _; _ ] | [ _; _; _ ] -> false
  | x :: y :: tail ->
    has_pair_of_specific_chars x y tail || has_pair_of_two_letters' (y :: tail)
;;

let has_pair_of_two_letters = String.to_seq %> List.of_seq %> has_pair_of_two_letters'

let rec has_bridge_letters' = function
  | [] | _ :: [] | [ _; _ ] -> false
  | x :: _ :: y :: _ when x = y -> true
  | _ :: tail -> has_bridge_letters' tail
;;

let has_bridge_letters = String.to_seq %> List.of_seq %> has_bridge_letters'

(* Main Boolean Logic *)
let is_string_nice string = has_pair_of_two_letters string && has_bridge_letters string

let solution =
  CCIO.(with_in "../inputs/05_large.txt" read_lines_l)
  |> CCList.find_all is_string_nice
  |> CCList.length
;;
