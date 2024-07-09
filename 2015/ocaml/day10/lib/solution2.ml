open Containers
open Solution1

let solution =
  IO.with_in "../inputs/10_large.txt" IO.read_all
  |> String.rtrim
  |> repeat_look_and_say 50
  |> String.length
;;
