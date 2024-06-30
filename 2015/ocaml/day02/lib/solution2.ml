let numbers_regexp = Re.Pcre.re "\\d+" |> Re.compile
let convert_dimensions string = Re.matches numbers_regexp string |> List.map int_of_string

let wrapping_size = function
  | [] | [ _ ] | [ _; _ ] -> 0
  | length :: width :: height :: _ ->
    let front_perimeter = 2 * (length + height)
    and side_perimeter = 2 * (width + height)
    and top_perimeter = 2 * (length + width) in
    let smallest_perimeter =
      List.fold_left min front_perimeter [ side_perimeter; top_perimeter ]
    and volume = length * width * height in
    smallest_perimeter + volume
;;

let solution =
  let open CCFun in
  CCIO.(with_in "../inputs/02_large.txt" read_lines_l)
  |> List.map (convert_dimensions %> wrapping_size)
  |> List.fold_left ( + ) 0
;;
