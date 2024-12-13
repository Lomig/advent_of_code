open Containers

let regexp =
  Re.alt
    [ Re.group @@ Re.str "do()"
    ; Re.group @@ Re.str "don't()"
    ; Re.seq
        [ Re.str "mul("
        ; Re.group @@ Re.repn Re.digit 1 (Some 3)
        ; Re.str ","
        ; Re.group @@ Re.repn Re.digit 1 (Some 3)
        ; Re.str ")"
        ]
    ]
  |> Re.compile
;;

let remove_disabled instructions =
  let rec aux acc is_enabled instructions =
    match instructions with
    | [] -> acc
    | "do()" :: tail -> aux acc true tail
    | "don't()" :: tail -> aux acc false tail
    | x :: xs ->
      (match is_enabled with
       | false -> aux acc false xs
       | true -> aux (x :: acc) true xs)
  in
  aux [] true instructions
;;

let solution =
  IO.with_in "../_inputs/03.txt" IO.read_all
  |> Re.matches regexp
  |> remove_disabled
  |> List.map Solution1.find_all_matches
  |> List.map (fun (a, b) -> int_of_string a * int_of_string b)
  |> List.fold_left ( + ) 0
;;
