let rec first_time_in_basement instructions current_floor step =
  match instructions, current_floor with
  | _, -1 -> step
  | [], _ -> 0
  | '(' :: tail, _ -> first_time_in_basement tail (current_floor + 1) (step + 1)
  | ')' :: tail, _ -> first_time_in_basement tail (current_floor - 1) (step + 1)
  | _ :: tail, _ -> first_time_in_basement tail current_floor (step + 1)
;;

let solution =
  let input =
    CCIO.with_in "../inputs/01_large.txt" CCIO.read_all |> String.to_seq |> List.of_seq
  in
  first_time_in_basement input 0 0
;;
