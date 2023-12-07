# frozen_string_literal: true

require_relative "card"
require_relative "hand"

class HandParser
  private attr_reader :input, :with_joker, :card_class

  def initialize(input:, with_joker: false)
    @input = input
    @with_joker = with_joker
    @card_class = with_joker ? CardWithJoker : Card
  end

  def parse
    input.map(&line_to_hand)
  end

  private

  def line_to_hand = lambda do |line|
    Hand.new(
      **line.split(" ").then(&transform_into_cards_and_bid),
      with_joker:
    )
  end

  def transform_into_cards_and_bid = lambda do |(raw_cards, raw_bid)|
    {
      cards: raw_cards.each_char.map { |raw_card| card_class.new(raw_card) },
      bid: raw_bid.to_i
    }
  end
end
