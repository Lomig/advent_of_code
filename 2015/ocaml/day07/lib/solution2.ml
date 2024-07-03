open Containers
open Solution1

let solution =
  let circuit =
    IO.with_in "../inputs/07_large.txt" IO.read_lines_l
    |> List.fold_left circuit_of_string StringMap.empty
  and wire_signals = StringMap.empty |> StringMap.add "b" Solution1.solution in
  fst (get_signal_from_wire "a" circuit wire_signals)
;;
