open Containers

module Input = struct
  let padded_day day = day |> string_of_int |> String.pad ~c:'0' 2

  let string_of_day day =
    IO.with_in ("../_inputs/" ^ padded_day day ^ ".txt") IO.read_all |> String.trim
  ;;

  let lines_of_day day =
    let lines =
      IO.with_in ("../_inputs/" ^ padded_day day ^ ".txt") IO.read_lines_l
      |> List.map String.trim
    in
    match List.rev lines with
    | "" :: tl_rev -> List.rev tl_rev
    | _ -> lines
  ;;
end

module List = struct
  let first = function
    | [] -> failwith "the list is empty"
    | x :: _ -> x
  ;;
end
