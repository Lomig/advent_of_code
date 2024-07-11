open Containers
module ReindeerMap = Map.Make (Reindeer)

type position =
  { distance : int
  ; points : int
  }

type race = position ReindeerMap.t

let get_or_create_position reindeer reindeers =
  match ReindeerMap.get reindeer reindeers with
  | None -> { distance = 0; points = 0 }
  | Some position -> position
;;

let update_reindeer_points top_distance race =
  let rec aux acc top_distance top_points reindeers =
    match reindeers with
    | [] -> acc, top_points
    | reindeer :: tail ->
      let position = get_or_create_position reindeer race in
      let points =
        if position.distance >= top_distance then position.points + 1 else position.points
      in
      let top_points = max top_points points in
      let acc = ReindeerMap.add reindeer { distance = position.distance; points } acc in
      aux acc top_distance top_points tail
  in
  aux ReindeerMap.empty top_distance 0 (ReindeerMap.keys race |> List.of_iter)
;;

let update_reindeer_positions elapsed race =
  let reindeers = ReindeerMap.keys race |> List.of_iter in
  let rec aux acc top_distance reindeers =
    match reindeers with
    | [] -> acc, top_distance
    | reindeer :: tail ->
      let position = get_or_create_position reindeer race in
      let distance = Solution1.distance_in_time elapsed reindeer in
      let acc = ReindeerMap.add reindeer { distance; points = position.points } acc in
      let top_distance = max distance top_distance in
      aux acc top_distance tail
  in
  let race, top_distance = aux ReindeerMap.empty 0 reindeers in
  update_reindeer_points top_distance race
;;

let race duration reindeers =
  let rec aux elapsed remaining top_points reindeers =
    match remaining with
    | 0 -> reindeers, top_points
    | _ ->
      let reindeers, top_points = update_reindeer_positions (elapsed + 1) reindeers in
      aux (elapsed + 1) (remaining - 1) top_points reindeers
  in
  aux 0 duration 0 reindeers
;;

let solution =
  IO.with_in "../inputs/14_large.txt" IO.read_lines_l
  |> List.fold_left
       (fun acc string ->
         let r = Reindeer.of_string string in
         ReindeerMap.add r { distance = 0; points = 0 } acc)
       ReindeerMap.empty
  |> race 2503
  |> snd
;;
