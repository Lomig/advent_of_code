# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/game"
require_relative "lib/game_parser"

class Day2 < AoC
  def result1 = games.sum(&:possible_score)

  def result2 = games.sum(&:power)

  private

  def games
    input.filter_map { |raw_game| Game.new(**GameParser.parse(raw_game)) }
  end
end
