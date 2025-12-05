(*=============================================================================
 * External Dependencies
 *===========================================================================*)
open Containers
open Utils

(*=============================================================================
 * Main Solution
 *===========================================================================*)
let compile_ranges list =
  (* Handles the case where 2 ranges cannot be merged perfectly and leaves a split range *)
  let handle_split ~accumulated ~merged_range ~split_range ~rest =
    let resorted_remaining = List.sort Range.compare (split_range :: rest) in
    match resorted_remaining with
    | first :: tail when Range.equal first split_range ->
      (* If the split range is the next one to merge, we already know it is not possible: it becomes the next to be processed *)
      merged_range :: accumulated, split_range, tail
    | _ ->
      (* If the split range is not the next remaining one, we continue as usual — maybe it will be mergeable in the future *)
      accumulated, merged_range, resorted_remaining
  in
  let rec process_ranges ~accumulated ~current_range ~remaining =
    match remaining with
    | [] -> current_range :: accumulated
    | next_range :: rest ->
      (match Range.compile current_range next_range with
       | [ merged_range ] ->
         process_ranges ~accumulated ~current_range:merged_range ~remaining:rest
       | [ merged_range; split_range ] ->
         let new_accumulated, new_current, new_remaining =
           handle_split ~accumulated ~merged_range ~split_range ~rest
         in
         process_ranges
           ~accumulated:new_accumulated
           ~current_range:new_current
           ~remaining:new_remaining
       | _ -> failwith "Range.compile must return exactly 1 or 2 ranges")
  in
  match list with
  | [] -> []
  | [ single_range ] -> [ single_range ]
  | first :: rest -> process_ranges ~accumulated:[] ~current_range:first ~remaining:rest
;;

let solution =
  let fresh_ranges, _ = AoC.Input.lines_of_day 5 |> Solution1.parse_input in
  List.sort Range.compare fresh_ranges
  |> compile_ranges
  |> List.fold_left (fun acc range -> acc + Range.length range) 0
;;
