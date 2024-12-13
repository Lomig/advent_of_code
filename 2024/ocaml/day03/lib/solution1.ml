open Containers

let regexp =
  Re.seq
    [ Re.str "mul("
    ; Re.group @@ Re.repn Re.digit 1 (Some 3)
    ; Re.str ","
    ; Re.group @@ Re.repn Re.digit 1 (Some 3)
    ; Re.str ")"
    ]
  |> Re.compile
;;

let find_all_matches regex_match =
  let numbers = Re.Group.all (Re.exec regexp regex_match) in
  numbers.(1), numbers.(2)
;;

let solution =
  IO.with_in "../_inputs/03.txt" IO.read_all
  |> Re.matches regexp
  |> List.map find_all_matches
  |> List.map (fun (a, b) -> int_of_string a * int_of_string b)
  |> List.fold_left ( + ) 0
;;
