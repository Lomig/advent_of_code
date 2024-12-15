# frozen_string_literal: true

require_relative "../aoc"
require_relative "warehouse"
require_relative "location"
require_relative "wall"
require_relative "box"
require_relative "crate"
require_relative "robot"

class Day15 < AoC
  SMALL_WAREHOUSE_SYMBOLS = {
    "#" => "#",
    "O" => "O",
    "." => ".",
    "@" => "@"
  }.freeze

  LARGE_WAREHOUSE_SYMBOLS = {
    "#" => "##",
    "O" => "[]",
    "." => "..",
    "@" => "@."
  }.freeze

  def result1
    @symbols = SMALL_WAREHOUSE_SYMBOLS
    warehouse_after_moves.boxes.sum(&:gps_value)
  end

  def result2
    @symbols = LARGE_WAREHOUSE_SYMBOLS
    warehouse_after_moves.crates.sum(&:gps_value)
  end

  private

  def warehouse_after_moves
    warehouse, moves = parse_input

    moves.each { |direction| warehouse.robot.move(direction:) }
    warehouse
  end

  def parse_input
    raw_locations = input.take_while { |line| line != "" }
    raw_moves = input[raw_locations.length + 1...]

    [warehouse(raw_locations), moves(raw_moves)]
  end

  def warehouse(raw_locations)
    raw_locations
      .each_with_index
      .with_object(Warehouse.new) do |(line, row), warehouse|
      column = 0
      line.each_char do |symbol|
        @symbols[symbol].each_char do |char|
          warehouse[row, column] = Location[char, row, column, warehouse]
          column += 1
        end
      end
    end
  end

  def moves(raw_moves)
    moves = {
      "^" => :top,
      ">" => :right,
      "v" => :bottom,
      "<" => :left
    }

    raw_moves
      .join
      .chars
      .map { |move| moves[move] }
  end
end
