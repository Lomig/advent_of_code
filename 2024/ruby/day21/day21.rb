# frozen_string_literal: true

require_relative "../aoc"
require_relative "keypad"

class Day21 < AoC
  def result1
    input.sum { |code| traverse_sequence(code, intermediate_robots: 2) * code.to_i }
  end

  def result2
    input.sum { |code| traverse_sequence(code, intermediate_robots: 25) * code.to_i }
  end

  private

  def traverse_sequence(code, intermediate_robots:)
    Keypad.new.count_keystrokes(
      code,
      depth: intermediate_robots,
      cache: {}
    )
  end
end
