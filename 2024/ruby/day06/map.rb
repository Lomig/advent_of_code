# frozen_string_literal: true

class Map
  private attr_reader :positions
  private attr_accessor :guard

  DIRECTIONS = {
    ?^ => Vector[-1, 0],
    ?> => Vector[0, 1],
    ?v => Vector[1, 0],
    ?< => Vector[0, -1]
  }.freeze

  def initialize(raw_map, guard:)
    @positions = deserialize(raw_map, guard)
  end

  def reach(guard:, position:)
    case positions[*position]
    when Obstacle then guard.turn_right
    when Void, Breadcrumb then guard.move(map: self)
    else guard.breadcrumbs = breadcrumbs
    end

    self
  end

  def mark(position:, direction:)
    positions[*position] = Breadcrumb.new(position:, direction:)
  end

  private

  def breadcrumbs
    positions.select { |position| position.is_a?(Breadcrumb) }
  end

  def deserialize(raw_map, guard)
    raw_map
      .each_with_index
      .with_object(Matrix.build(raw_map.row_count, raw_map.column_count) { nil }) do |(symbol, row, column), positions|
      position = Vector[row, column]
      next positions[*position] = Void.new(position:) if symbol == "."
      next positions[*position] = Obstacle.new(position:) if symbol == "#"

      direction = DIRECTIONS[symbol]
      guard.place(position:, direction:)
      positions[*position] = Breadcrumb.new(position:, direction:)
    end
  end
end
