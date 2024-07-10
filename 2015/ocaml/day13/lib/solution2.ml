open Containers
open Solution1

let add_myself_to_table happiness_table guests =
  ( List.fold_left
      (fun happiness_table guest ->
        let duo = Duo.make "me" guest in
        HappinessMap.add duo { duo; amount = 0 } happiness_table)
      happiness_table
      guests
  , "me" :: guests )
;;

let solution =
  let happiness_table =
    IO.with_in "../inputs/13_large.txt" IO.read_lines_l
    |> List.fold_left
         (fun table str -> store_happiness (happiness_of_string str) table)
         HappinessMap.empty
  in
  let guests = guest_list happiness_table in
  let happiness_table, guests = add_myself_to_table happiness_table guests in
  permutations guests
  |> List.map (fun x -> compute_total_happiness 0 x (List.hd x) happiness_table)
  |> List.fold_left max 0
;;
