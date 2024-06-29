# frozen_string_literal: true

require_relative "card_parser"
require_relative "card"

class Wallet
  private attr_reader :cards

  def initialize(raw_cards:)
    @cards = raw_cards.to_h(&parse_cards)

    @cards.values.each { |card_card| card_card.scratch }
  end

  def add_cards(id:, rewarded_card_count:, copies:)
    1.upto(rewarded_card_count) do |i|
      break unless (card = cards[id + i])

      card.add_copies!(count: copies)
    end
  end

  def card_score = cards.values.sum(&:score)

  def card_count = cards.values.sum(&:copies)

  private

  def parse_cards = lambda do |raw_card|
    id, winning, scratched = CardParser.parse(raw_card)
    [id, Card.new(wallet: self, id:, winning:, scratched:)]
  end
end
