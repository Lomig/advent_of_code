# frozen_string_literal: true

module RaceParser
  extend self

  def parse(input) = numbers_from(input[0]).zip(numbers_from(input[1]))

  def parse_with_fixed_kerning(input)
    input
      .map { |line| line.delete(" ") }
      .then { |lines| parse(lines) }
  end

  private

  def numbers_from(line) = line.scan(/\d+/).map(&:to_i)
end
