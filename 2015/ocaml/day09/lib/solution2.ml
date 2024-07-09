open Containers
open Solution1

let greatest_distance a b =
  match a with
  | None -> Some b
  | Some a -> Some (max a b)
;;

let solution =
  let airports =
    IO.with_in "../inputs/09_large.txt" IO.read_lines_l
    |> List.fold_left airports_of_string Airports.empty
  in
  let trip =
    { current_stopover = "North Pole"
    ; missing_destinations = Airports.keys airports |> List.of_iter
    ; distance = 0
    }
  in
  travel greatest_distance [ trip ] None airports
;;
