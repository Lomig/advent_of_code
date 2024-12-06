# frozen_string_literal: true

require "parallel"

require_relative "../aoc"

require_relative "guard"
require_relative "map"
require_relative "map_elements"

require_relative "jump_table"

class Day6 < AoC
  input_as :matrix

  def result1 = breadcrumbs.count

  def result2
    table = JumpTable.new(input)

    breadcrumbs.filter_map do |possible_block|
      current_state = table.initial_state
      next if possible_block.position == current_state[0]

      table.add_block(possible_block.position)
      visited_states = Set.new << current_state

      loop do
        current_state = table[current_state]
        break false if current_state == :out
        break true if visited_states.include?(current_state)

        visited_states << current_state
      end => is_loop

      table.remove_block(possible_block.position)
      is_loop
    end.count
  end

  private

  def breadcrumbs
    guard = Guard.new

    guard
      .tour!(map: Map.new(input, guard:))
      .breadcrumbs
  end
end
