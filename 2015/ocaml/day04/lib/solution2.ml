let has_hash_zeroes hash =
  let chars = hash |> String.to_seq |> List.of_seq in
  match chars with
  | [] | _ :: [] | [ _; _ ] | [ _; _; _ ] | [ _; _; _; _ ] | [ _; _; _; _; _ ] -> false
  | '0' :: '0' :: '0' :: '0' :: '0' :: '0' :: _ -> true
  | _ -> false
;;

let check_suffix secret_key suffix =
  secret_key ^ string_of_int suffix
  |> Digest.MD5.string
  |> Digest.MD5.to_hex
  |> has_hash_zeroes
;;

let rec find_first_match_in_range secret_key start finish =
  let check_suffix = check_suffix secret_key start in
  match check_suffix, finish - start with
  | true, _ -> Some start
  | false, 0 -> None
  | _ -> find_first_match_in_range secret_key (start + 1) finish
;;

let find_first_match pool secret_key =
  let range_size = 10000 in
  let find_in_ranges range_start =
    let range_finish = range_start + range_size in
    Domainslib.Task.async pool (fun _ ->
      find_first_match_in_range secret_key range_start range_finish)
  in
  let rec parallel_find_first_match range_start =
    let result =
      CCList.init 4 (fun i -> find_in_ranges (range_start + (i * range_size)))
      |> CCList.map (fun task -> Domainslib.Task.await pool task)
      |> CCList.find_opt (function
        | None -> false
        | Some _ -> true)
    in
    match result with
    | Some (Some x) -> x
    | _ -> parallel_find_first_match (range_start + (4 * range_size))
  in
  parallel_find_first_match 0
;;

let solution =
  let pool = Domainslib.Task.setup_pool ~num_domains:4 ()
  and secret_key = CCIO.(with_in "../inputs/04_large.txt" read_all) in
  CCFun.finally
    ~h:(fun () -> Domainslib.Task.teardown_pool pool)
    ~f:(fun () -> Domainslib.Task.run pool (fun _ -> find_first_match pool secret_key))
;;
