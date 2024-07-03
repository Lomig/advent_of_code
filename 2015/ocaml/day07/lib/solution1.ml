open Containers
module StringMap = Map.Make (String)

type element =
  | Value of string
  | And of string * string
  | Or of string * string
  | LShift of string * string
  | RShift of string * string
  | Not of string

type expression = element * string

let expression_of_string string : expression =
  match String.split_on_char ' ' string with
  | [ value; "->"; target ] -> Value value, target
  | [ "NOT"; value; "->"; target ] -> Not value, target
  | [ value1; "AND"; value2; "->"; target ] -> And (value1, value2), target
  | [ value1; "OR"; value2; "->"; target ] -> Or (value1, value2), target
  | [ value1; "LSHIFT"; value2; "->"; target ] -> LShift (value1, value2), target
  | [ value1; "RSHIFT"; value2; "->"; target ] -> RShift (value1, value2), target
  | _ -> failwith ("Unable to parse line '" ^ string ^ "'")
;;

let circuit_of_string circuit string =
  let operation, wire = string |> expression_of_string in
  StringMap.add wire operation circuit
;;

let rec get_signal_from_wire wire circuit wire_signals =
  match int_of_string_opt wire with
  | Some value -> value, wire_signals
  | None ->
    (match StringMap.get wire wire_signals with
     | Some signal -> signal, wire_signals
     | None ->
       let operation = StringMap.get wire circuit in
       (match operation with
        | None -> failwith ("The wire " ^ wire ^ " is not connected")
        | Some op ->
          get_signal_from_wire wire circuit (execute op wire circuit wire_signals)))

and execute operation target circuit wire_signals =
  let value, wire_signals =
    match operation with
    | Value v -> get_signal_from_wire v circuit wire_signals
    | Not v -> bitwise_not v circuit wire_signals
    | And (v1, v2) -> bitwise_logic ( land ) v1 v2 circuit wire_signals
    | Or (v1, v2) -> bitwise_logic ( lor ) v1 v2 circuit wire_signals
    | LShift (v1, v2) -> bitwise_logic ( lsl ) v1 v2 circuit wire_signals
    | RShift (v1, v2) -> bitwise_logic ( lsr ) v1 v2 circuit wire_signals
  in
  StringMap.add target value wire_signals

and bitwise_not value circuit wire_signals =
  let value, wire_signals = get_signal_from_wire value circuit wire_signals in
  lnot value, wire_signals

and bitwise_logic f value1 value2 circuit wire_signals =
  let value1, wire_signals = get_signal_from_wire value1 circuit wire_signals in
  let value2, wire_signals = get_signal_from_wire value2 circuit wire_signals in
  f value1 value2, wire_signals
;;

let solution =
  let circuit =
    IO.with_in "../inputs/07_large.txt" IO.read_lines_l
    |> List.fold_left circuit_of_string StringMap.empty
  and wire_signals = StringMap.empty in
  fst (get_signal_from_wire "a" circuit wire_signals)
;;
