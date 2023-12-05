# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/almanach"
require_relative "lib/almanach_parser"

class Day5 < AoC
  def result1 = almanach.seeds_smaller_location_id

  def result2 = almanach.seed_range_smaller_location_id

  private

  def almanach = Almanach.new(**AlmanachParser.parse(input))
end
