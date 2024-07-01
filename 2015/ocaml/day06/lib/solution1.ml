type light_state =
  | On
  | Off

let turn_on (_ : light_state) = On
let turn_off (_ : light_state) = Off

let toggle = function
  | On -> Off
  | Off -> On
;;

type coordinates = int * int

type action =
  { command : light_state -> light_state
  ; start : coordinates
  ; finish : coordinates
  }

let command_of_string = function
  | "on" | "turn_on" | "TurnOn" -> turn_on
  | "toggle" | "Toggle" -> toggle
  | _ -> turn_off
;;

let action_regexp =
  Re.Pcre.re "(toggle|off|on) (\\d+),(\\d+) through (\\d+),(\\d+)" |> Re.compile
;;

let action_of_string string =
  let matches = Re.exec action_regexp string |> Re.Group.all in
  match matches with
  | [| _; cmd; start_x; start_y; finish_x; finish_y |] ->
    { command = command_of_string cmd
    ; start = int_of_string start_x, int_of_string start_y
    ; finish = int_of_string finish_x, int_of_string finish_y
    }
  | _ -> failwith ("Cannot get instruction from " ^ string)
;;

let rec change_column command line current_column last_column grid =
  grid.(line).(current_column) <- command grid.(line).(current_column);
  match current_column with
  | y when y = last_column -> grid
  | _ -> change_column command line (current_column + 1) last_column grid
;;

let rec change_line action current_line grid =
  let grid =
    change_column action.command current_line (snd action.start) (snd action.finish) grid
  in
  match current_line with
  | x when x = fst action.finish -> grid
  | _ -> change_line action (current_line + 1) grid
;;

let execute action grid = change_line action (fst action.start) grid

let count_lightened_lights grid =
  grid
  |> CCArray.fold_left Array.append [||]
  |> CCArray.filter (fun light -> light = On)
  |> CCArray.length
;;

let solution =
  let grid = CCArray.make_matrix 1000 1000 Off in
  CCIO.(with_in "../inputs/06_large.txt" read_lines_l)
  |> List.map action_of_string
  |> List.fold_left (fun _ action -> execute action grid) grid
  |> count_lightened_lights
;;
