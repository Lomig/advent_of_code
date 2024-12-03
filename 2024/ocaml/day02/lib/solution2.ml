open Containers

let dampened_reports report =
  report :: List.mapi (fun i _ -> List.filteri (fun j _ -> i <> j) report) report
;;

let is_valid_dampened_reports reports =
  List.exists (fun r -> Solution1.is_report_valid r) reports
;;

let solution =
  IO.with_in "../_inputs/02.txt" IO.read_lines_l
  |> List.map @@ String.split ~by:" "
  |> List.map @@ List.map Int.of_string_exn
  |> List.map dampened_reports
  |> List.filter (fun r -> is_valid_dampened_reports r)
  |> List.length
;;
