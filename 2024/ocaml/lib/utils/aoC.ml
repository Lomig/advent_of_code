open Containers

module Input = struct
  let string_of_day day =
    IO.with_in ("../_inputs/" ^ string_of_int day ^ ".txt") IO.read_all |> String.trim
  ;;

  let lines_of_day day =
    IO.with_in ("../_inputs/" ^ string_of_int day ^ ".txt") IO.read_lines_l
    |> List.map String.trim
  ;;
end
