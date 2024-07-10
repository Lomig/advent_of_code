open Containers
module StringSet = Set.Make (String)

module Duo = struct
  type t = string * string

  let compare (s1, s2) (t1, t2) =
    match String.compare s1 t1 with
    | 0 -> String.compare s2 t2
    | c -> c
  ;;

  let make s1 s2 =
    match String.compare s1 s2 <= 0 with
    | true -> s1, s2
    | false -> s2, s1
  ;;
end

type happiness =
  { duo : Duo.t
  ; amount : int
  }

module HappinessMap = Map.Make (Duo)

type happiness_map = happiness HappinessMap.t

let compute_amount verb amount =
  let amount = int_of_string amount in
  match verb with
  | "gain" -> amount
  | "lose" -> -amount
  | _ -> failwith "Parsing error"
;;

let happiness_of_string string =
  match String.split_on_char ' ' string with
  | guest1
    :: "would"
    :: gain_or_lose
    :: amount
    :: "happiness"
    :: "units"
    :: "by"
    :: "sitting"
    :: "next"
    :: "to"
    :: guest2
    :: _ ->
    let guest2 = String.sub guest2 0 (String.length guest2 - 1) in
    { duo = Duo.make guest1 guest2; amount = compute_amount gain_or_lose amount }
  | _ -> failwith ("Unable to parse `" ^ string ^ "`")
;;

let store_happiness happiness happiness_table =
  let duo = happiness.duo in
  match HappinessMap.get duo happiness_table with
  | None -> HappinessMap.add duo happiness happiness_table
  | Some current_happiness ->
    HappinessMap.add
      duo
      { duo; amount = current_happiness.amount + happiness.amount }
      happiness_table
;;

let guest_list happiness_table =
  HappinessMap.fold
    (fun (g1, g2) _ guest_set -> StringSet.add g1 (StringSet.add g2 guest_set))
    happiness_table
    StringSet.empty
  |> StringSet.to_list
;;

let rec permutations list =
  let insert_element_in_all_positions x list =
    let rec aux previous_first_elems acc list =
      match list with
      | [] -> List.rev (x :: previous_first_elems) :: acc
      | head :: tail ->
        let list = List.rev_append previous_first_elems (x :: list) in
        aux (head :: previous_first_elems) (list :: acc) tail
    in
    aux [] [] list
  in
  match list with
  | [] -> []
  | [ x ] -> [ [ x ] ]
  | head :: tail ->
    List.fold_left
      (fun acc l -> acc @ insert_element_in_all_positions head l)
      []
      (permutations tail)
;;

let rec compute_total_happiness acc guests first_guest happiness_table =
  match guests with
  | [] -> acc
  | [ guest ] ->
    let duo = Duo.make first_guest guest in
    (match HappinessMap.get duo happiness_table with
     | None -> failwith "Unexpected Error"
     | Some happiness -> acc + happiness.amount)
  | guest1 :: guest2 :: tail ->
    let duo = Duo.make guest1 guest2 in
    let acc =
      match HappinessMap.get duo happiness_table with
      | None -> failwith "Unexpected Error"
      | Some happiness -> acc + happiness.amount
    in
    compute_total_happiness acc (guest2 :: tail) first_guest happiness_table
;;

let solution =
  let happiness_table =
    IO.with_in "../inputs/13_large.txt" IO.read_lines_l
    |> List.fold_left
         (fun table str -> store_happiness (happiness_of_string str) table)
         HappinessMap.empty
  in
  guest_list happiness_table
  |> permutations
  |> List.map (fun x -> compute_total_happiness 0 x (List.hd x) happiness_table)
  |> List.fold_left max 0
;;
