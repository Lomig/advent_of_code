open Containers
module Flights = Map.Make (String)

type flights = int Flights.t

type airport =
  { name : string
  ; flights : flights
  }

module Airports = Map.Make (String)

type airports = airport Airports.t

let update_airport airport arrival distance =
  let flights = airport.flights |> Flights.add arrival distance in
  { name = airport.name; flights }
;;

let add_airport' departure arrival distance (airports : airports) : airports =
  let airport =
    match Airports.get departure airports with
    | None -> { name = departure; flights = Flights.empty }
    | Some airport -> airport
  in
  Airports.add departure (update_airport airport arrival distance) airports
;;

let add_airport port1 port2 dist airports =
  let airports = add_airport' port1 port2 dist airports in
  add_airport' port2 port1 dist airports
;;

let airports_of_string airports string =
  match String.split_on_char ' ' string with
  | from :: "to" :: dest :: "=" :: dist :: _ ->
    add_airport from dest (int_of_string dist) airports
  | _ -> failwith ("Unable to parse string " ^ string)
;;

type trip =
  { current_stopover : string
  ; missing_destinations : string list
  ; distance : int
  }

let add_next_trips rule_func airports distance routes trip =
  let create_next_trip trips destination =
    let missing_destinations =
      List.filter (String.( <> ) destination) trip.missing_destinations
    in
    let airport =
      match Airports.get trip.current_stopover airports, trip.current_stopover with
      | _, "North Pole" -> { name = "North Pole"; flights = Flights.empty }
      | None, _ -> failwith ("Missing Airport " ^ trip.current_stopover)
      | Some airport, _ -> airport
    in
    let next_flight_distance =
      match Flights.get destination airport.flights, trip.current_stopover with
      | _, "North Pole" -> 0
      | None, _ ->
        failwith ("Missing flights from " ^ trip.current_stopover ^ " to " ^ destination)
      | Some flight_distance, _ -> flight_distance
    in
    let distance = trip.distance + next_flight_distance in
    { current_stopover = destination; missing_destinations; distance } :: trips
  in
  match trip.missing_destinations with
  | [] -> routes, rule_func distance trip.distance
  | _ -> List.fold_left create_next_trip routes trip.missing_destinations, distance
;;

let rec travel rule_func routes distance airports =
  match routes, distance with
  | [], None -> failwith "Unable to compute distance"
  | [], Some distance -> distance
  | head :: tail, _ ->
    let routes, distance = add_next_trips rule_func airports distance tail head in
    travel rule_func routes distance airports
;;

let smallest_distance a b =
  match a with
  | None -> Some b
  | Some a -> Some (min a b)
;;

let solution =
  let airports =
    IO.with_in "../inputs/09_large.txt" IO.read_lines_l
    |> List.fold_left airports_of_string Airports.empty
  in
  let trip =
    { current_stopover = "North Pole"
    ; missing_destinations = Airports.keys airports |> List.of_iter
    ; distance = 0
    }
  in
  travel smallest_distance [ trip ] None airports
;;
