(*=============================================================================
 * Main Solution
 *===========================================================================*)

let solution =
  Solution1.move_crates_around_warehouse
    ~warehouse_builder:Warehouse.of_enlarged_list
    ~box_retriever:Warehouse.get_crates
;;
