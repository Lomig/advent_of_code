open Containers

let has_red_value fields =
  List.exists
    (fun (_, value) ->
      match value with
      | `String "red" -> true
      | _ -> false)
    fields
;;

let filter_red_then_sum json =
  let rec aux acc stack_of_json =
    match stack_of_json with
    | [] -> acc
    | head :: tail ->
      (match head with
       | `Assoc fields when has_red_value fields -> aux acc tail
       | `Assoc fields ->
         let new_stack =
           List.fold_left (fun stack (_, value) -> value :: stack) tail fields
         in
         aux acc new_stack
       | `List items ->
         let new_stack = List.fold_left (fun stack value -> value :: stack) tail items in
         aux acc new_stack
       | `Int i -> aux (acc + i) tail
       | _ -> aux acc tail)
  in
  aux 0 [ json ]
;;

let solution = Yojson.Basic.from_file "../inputs/12_large.txt" |> filter_red_then_sum
