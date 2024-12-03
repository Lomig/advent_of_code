let similarity n list =
  List.fold_left (fun acc x -> if x = n then acc + x else acc) 0 list
;;

let sum_similarities (l1, l2) = List.fold_left (fun acc n -> acc + similarity n l2) 0 l1
let solution = Solution1.(parse_input |> split_list) |> sum_similarities
