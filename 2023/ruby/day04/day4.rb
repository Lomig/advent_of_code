# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/wallet"

class Day4 < AoC
  def result1 = Wallet.new(raw_cards: input).card_score

  def result2 = Wallet.new(raw_cards: input).card_count
end
