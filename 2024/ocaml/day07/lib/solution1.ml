open Containers

type state =
  { value : int
  ; partial_result : int
  ; elements : int list
  }

let state_of_string string =
  match String.split ~by:": " string with
  | [ raw_value; raw_elements ] ->
    let elements = raw_elements |> String.split ~by:" " |> List.map int_of_string in
    { value = int_of_string raw_value
    ; partial_result = List.hd elements
    ; elements = List.tl elements
    }
  | _ -> failwith "Invalid input format"
;;

let is_valid_equation state =
  let rec aux queue =
    match queue with
    | [] -> false
    | { value; partial_result; elements } :: _
      when value = partial_result && List.is_empty elements -> true
    | { elements; _ } :: xs when List.is_empty elements -> aux xs
    | { value; partial_result; _ } :: xs when partial_result > value -> aux xs
    | { value; partial_result; elements } :: xs ->
      let plus_state =
        { value
        ; partial_result = partial_result + List.hd elements
        ; elements = List.tl elements
        }
      in
      let mult_state =
        { value
        ; partial_result = partial_result * List.hd elements
        ; elements = List.tl elements
        }
      in
      aux (plus_state :: mult_state :: xs)
  in
  aux [ state ]
;;

let solution =
  IO.with_in "../_inputs/07.txt" IO.read_lines_l
  |> List.map state_of_string
  |> List.filter is_valid_equation
  |> List.fold_left (fun acc { value; _ } -> acc + value) 0
;;
