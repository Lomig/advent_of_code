# frozen_string_literal: true

require_relative "../aoc"
require_relative "onsen"

class Day19 < AoC
  def result1 = onsen.available_designs.count

  def result2 = onsen.all_designs_count

  private

  def onsen
    towels = input[0].split(", ")
    designs = input[2..]

    Onsen.new(designs:, towels:)
  end
end
