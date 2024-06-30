open Coordinates
module CoordinatesSet = Set.Make (Coordinates)

type santa =
  | Human
  | Robot

let next_santa = function
  | Human -> Robot
  | Robot -> Human
;;

let rec move_and_register_coordinates
  santa_type
  human_position
  robot_position
  coordinates
  directions
  =
  let updated_coordinates =
    coordinates |> CoordinatesSet.add human_position |> CoordinatesSet.add robot_position
  in
  match directions with
  | [] -> coordinates
  | head :: tail ->
    let next_santa = next_santa santa_type
    and new_positions =
      match santa_type with
      | Human -> Coordinates.move head human_position, robot_position
      | Robot -> human_position, Coordinates.move head robot_position
    in
    move_and_register_coordinates
      next_santa
      (fst new_positions)
      (snd new_positions)
      updated_coordinates
      tail
;;

let solution =
  CCIO.(with_in "../inputs/03_large.txt" read_all)
  |> String.to_seq
  |> List.of_seq
  |> move_and_register_coordinates Human (0, 0) (0, 0) CoordinatesSet.empty
  |> CoordinatesSet.to_list
  |> List.length
;;
