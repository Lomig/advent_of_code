open Containers

let numbers_regexp = Re.Pcre.re "-?\\d+" |> Re.compile
let add_numbers_as_strings acc number = acc + int_of_string number

let compute string =
  string |> Re.matches numbers_regexp |> List.fold_left add_numbers_as_strings 0
;;

let solution = IO.with_in "../inputs/12_large.txt" IO.read_all |> String.trim |> compute
