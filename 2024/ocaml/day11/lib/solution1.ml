open Containers

module Cache = Hashtbl.Make (struct
    type t = int * int

    let equal (a1, b1) (a2, b2) = a1 = a2 && b1 = b2
    let hash = Hashtbl.hash
  end)

let split_int_if_even_length n =
  let s = string_of_int n in
  let length = String.length s in
  match length mod 2 with
  | 0 ->
    Some
      ( int_of_string (String.sub s 0 (length / 2))
      , int_of_string (String.sub s (length / 2) (length / 2)) )
  | _ -> None
;;

let rec count_stones ?(cache = Cache.create 1000) blinks stone =
  match blinks with
  | 0 -> 1
  | _ ->
    (match Cache.find_opt cache (stone, blinks) with
     | Some count -> count
     | None ->
       let result =
         match stone with
         | 0 -> count_stones ~cache (blinks - 1) 1
         | _ ->
           (match split_int_if_even_length stone with
            | Some (stone1, stone2) ->
              count_stones ~cache (blinks - 1) stone1
              + count_stones ~cache (blinks - 1) stone2
            | None -> count_stones ~cache (blinks - 1) (stone * 2024))
       in
       Cache.add cache (stone, blinks) result;
       result)
;;

let blink times =
  IO.with_in "../_inputs/11.txt" IO.read_all
  |> String.trim
  |> String.split_on_char ' '
  |> List.map int_of_string
  |> List.fold_left (fun acc stone -> acc + count_stones times stone) 0
;;

let solution = blink 25
