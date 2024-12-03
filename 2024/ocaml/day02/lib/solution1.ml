open Containers

let is_report_valid report =
  let is_report_valid' report op =
    let rec aux report =
      match report with
      | [] | [ _ ] -> true
      | x :: y :: _ when op x y || abs (y - x) > 3 -> false
      | _ :: xs -> aux xs
    in
    aux report
  in
  is_report_valid' report ( <= ) || is_report_valid' report ( >= )
;;

let solution =
  IO.with_in "../_inputs/02.txt" IO.read_lines_l
  |> List.map @@ String.split ~by:" "
  |> List.map @@ List.map Int.of_string_exn
  |> List.filter (fun report -> is_report_valid report)
  |> List.length
;;
