open Containers

let distance_in_time time (reindeer : Reindeer.t) =
  let complete_cycles = time / (reindeer.fly_time + reindeer.rest_time) in
  let remaining_time =
    time - (complete_cycles * (reindeer.fly_time + reindeer.rest_time))
  in
  let remaining_flight_time = min remaining_time reindeer.fly_time in
  reindeer.speed * ((complete_cycles * reindeer.fly_time) + remaining_flight_time)
;;

let solution =
  IO.with_in "../inputs/14_large.txt" IO.read_lines_l
  |> List.fold_left
       (fun acc string ->
         let r = Reindeer.of_string string in
         max acc (distance_in_time 2503 r))
       0
;;
