# frozen_string_literal: true

require_relative "../aoc"
require_relative "lib/schematic"
require_relative "lib/parts/parser"
require_relative "lib/parts/factory"
require_relative "lib/parts/generic_part"
require_relative "lib/parts/mechanism"
require_relative "lib/parts/gear"

class Day3 < AoC
  input_as :matrix

  def result1
    Schematic
      .new(matrix: input)
      .then { |schematic| schematic.parts.sum(&:serial_number) }
  end

  def result2
    Schematic
      .new(matrix: input)
      .then { |schematic| schematic.parts.sum(&:power) }
  end
end
