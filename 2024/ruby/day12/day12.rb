# frozen_string_literal: true

require_relative "../aoc"
require_relative "region"
require_relative "crop"

class Day12 < AoC
  input_as :matrix

  # custom_input <<~TXT
  #   AAAA
  #   BBCD
  #   BBCC
  #   EEEC
  # TXT

  def result1 = regions.sum(&:price)

  def result2 = regions.sum(&:discounted_price)

  private

  def regions
    field
      .values
      .map(&:region)
      .uniq
  end

  def field
    field = {}

    input.each_with_index do |letter, row, column|
      field[[row, column]] = Crop.new(letter, row, column)
    end

    field.each do |(row, column), crop|
      crop
        .add_neighbour(field[[row - 1, column]])
        .add_neighbour(field[[row + 1, column]])
        .add_neighbour(field[[row, column - 1]])
        .add_neighbour(field[[row, column + 1]])
    end.values.each(&:enclose!)

    field
  end
end
