# frozen_string_literal: true

class JumpTable
  DIRECTIONS = {
    ?^ => Vector[-1, 0],
    ?> => Vector[0, 1],
    ?v => Vector[1, 0],
    ?< => Vector[0, -1]
  }.freeze

  attr_reader :initial_state
  private attr_reader :raw_map

  def initialize(raw_map)
    @raw_map = raw_map
    @jump_table = deserialize
  end

  def [](state) = @jump_table[state]

  def add_block(position) = change_cell(position, "#")

  def remove_block(position) = change_cell(position, ".")

  def change_cell(position, symbol)
    raw_map[*position] = symbol
    DIRECTIONS.values.each do |direction|
      x, y = *position

      [Vector[x - 1, y], Vector[x + 1, y], Vector[x, y - 1], Vector[x, y + 1]].each do |new_position|
        @jump_table[[new_position, direction]] = compute_jump(new_position, direction)
      end
    end
  end

  private

  def deserialize
    raw_map.each_with_index.with_object({}) do |(symbol, row, column), jump_table|
      position = Vector[row, column]
      next if symbol == "#"

      @initial_state = [position, DIRECTIONS[symbol]] if DIRECTIONS.key?(symbol)
      DIRECTIONS
        .values
        .each { |direction| jump_table[[position, direction]] = compute_jump(position, direction) }
    end
  end

  def compute_jump(position, direction)
    next_position = position + direction
    return :out if next_position.any?(&:negative?) || next_position[0] >= raw_map.row_count || next_position[1] >= raw_map.column_count

    return [next_position, direction] unless raw_map[*next_position] == "#"

    [position, Vector[direction[1], -direction[0]]]
  end
end
