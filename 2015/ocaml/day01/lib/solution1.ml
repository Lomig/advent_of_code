let count_parenthesis_type (open_parenthesis, close_parenthesis) char =
  match char with
  | '(' -> open_parenthesis + 1, close_parenthesis
  | ')' -> open_parenthesis, close_parenthesis + 1
  | _ -> open_parenthesis, close_parenthesis
;;

let solution =
  let input = CCIO.with_in "../inputs/01_large.txt" CCIO.read_all in
  let up, down = String.fold_left count_parenthesis_type (0, 0) input in
  up - down
;;
