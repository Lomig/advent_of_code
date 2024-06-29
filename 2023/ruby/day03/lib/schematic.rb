# frozen_string_literal: true

require_relative "parts/parser"

class Schematic
  attr_reader :parts
  private attr_reader :matrix

  def initialize(matrix:)
    @matrix = matrix
    @parts = Parts::Parser.new(matrix:, schematic: self).parse
  end

  def neighbours(part)
    parts.select do |neighbour|
      next if neighbour == part
      next if neighbour_in_distant_row?(part:, neighbour:)

      neighbour_in_adjacent_column?(part:, neighbour:)
    end
  end

  private

  def neighbour_in_distant_row?(part:, neighbour:)
    (neighbour.row - part.row).abs > 1
  end

  def neighbour_in_adjacent_column?(part:, neighbour:)
    part.neighbouring_range.intersect?(neighbour.range) ||
      neighbour.neighbouring_range.intersect?(part.range)
  end
end
