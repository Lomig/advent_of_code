let numbers_regexp = Re.Pcre.re "\\d+" |> Re.compile
let convert_dimensions string = Re.matches numbers_regexp string |> List.map int_of_string

let wrapping_size = function
  | [] | [ _ ] | [ _; _ ] -> 0
  | length :: width :: height :: _ ->
    let front_area = length * height
    and side_area = width * height
    and top_area = length * width in
    let smallest_area = List.fold_left min front_area [ side_area; top_area ] in
    (2 * front_area) + (2 * side_area) + (2 * top_area) + smallest_area
;;

let solution =
  let open CCFun in
  CCIO.(with_in "../inputs/02_large.txt" read_lines_l)
  |> List.map (convert_dimensions %> wrapping_size)
  |> List.fold_left ( + ) 0
;;
