open Coordinates
module CoordinatesSet = Set.Make (Coordinates)

let rec move_and_register_coordinates position coordinates directions =
  let updated_coordinates = CoordinatesSet.add position coordinates in
  match directions with
  | [] -> coordinates
  | head :: tail ->
    move_and_register_coordinates
      (Coordinates.move head position)
      updated_coordinates
      tail
;;

let solution =
  CCIO.(with_in "../inputs/03_large.txt" read_all)
  |> String.to_seq
  |> List.of_seq
  |> move_and_register_coordinates (0, 0) CoordinatesSet.empty
  |> CoordinatesSet.to_list
  |> List.length
;;
