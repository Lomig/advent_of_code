# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/hand_parser"
require_relative "lib/game"

class Day7 < AoC
  def result1
    Game.new(
      HandParser.new(input:).parse
    ).winnings
  end

  def result2
    Game.new(
      HandParser.new(input:, with_joker: true).parse
    ).winnings
  end
end
