# frozen_string_literal: true

class Game
  private attr_reader :hands

  def initialize(hands)
    @hands = hands
  end

  def winnings
    hands
      .sort
      .each_with_index
      .sum(&hand_winnings)
  end

  private

  def hand_winnings = lambda do |(hand, rank)|
    hand.bid * (rank + 1)
  end
end
