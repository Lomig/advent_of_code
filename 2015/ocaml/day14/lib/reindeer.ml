type t =
  { name : string
  ; speed : int
  ; fly_time : int
  ; rest_time : int
  }

let compare r1 r2 = String.compare r1.name r2.name
let make (name, speed, fly_time, rest_time) = { name; speed; fly_time; rest_time }

let of_string string =
  match String.split_on_char ' ' string with
  | name
    :: _
    :: _
    :: speed
    :: _
    :: _
    :: fly_time
    :: _
    :: _
    :: _
    :: _
    :: _
    :: _
    :: rest_time
    :: _ ->
    make (name, int_of_string speed, int_of_string fly_time, int_of_string rest_time)
  | _ -> failwith ("Error parsing reindeer `" ^ string ^ "`")
;;
