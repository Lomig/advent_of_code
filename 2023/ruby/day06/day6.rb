# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/race"
require_relative "lib/race_parser"

class Day6 < AoC
  def result1
    RaceParser
      .parse(input)
      .map { |raw_race| Race.new(raw_race) }
      .inject(1) { |result, race| result * race.winning_move_count }
  end

  def result2
    RaceParser
      .parse_with_fixed_kerning(input)
      .map { |raw_race| Race.new(raw_race) }
      .inject(1) { |result, race| result * race.winning_move_count }
  end
end
