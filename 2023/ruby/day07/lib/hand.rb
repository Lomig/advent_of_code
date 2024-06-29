# frozen_string_literal: true

class Hand
  include Comparable

  JOKER = CardWithJoker.new("J")

  attr_reader :cards, :card_copies, :type, :bid

  def initialize(cards:, bid:, with_joker: false)
    @cards = cards
    @card_copies = cards.group_by(&:itself).to_h { |card, copies| [card, copies.count] }
    @bid = bid
    @with_joker = with_joker
  end

  def <=>(other)
    if value == other.value
      5.times do |i|
        next if cards[i] == other.cards[i]

        return cards[i] <=> other.cards[i]
      end
    end

    value <=> other.value
  end

  def value
    @value ||= case count_card_values
    in [5, *] then 6
    in [4, *] then 5
    in [3, 2, *] then 4
    in [3, _, *] then 3
    in [2, 2, *] then 2
    in [2, _, *] then 1
    else 0
    end
  end

  private

  def with_joker? = @with_joker

  def count_card_values
    card_counts = with_joker? ? cards_with_joker : card_copies

    card_counts
      .values
      .sort
      .reverse
  end

  def cards_with_joker
    return card_copies unless card_copies.key?(JOKER)
    return card_copies if card_copies.keys.all?(JOKER)

    card_copies.merge({
      JOKER => 0,
      best_card => card_copies[best_card] + card_copies[JOKER]
    })
  end

  def best_card
    return @best_cards if defined?(@best_cards)

    cards_without_joker = card_copies.except(JOKER)
    max_value = cards_without_joker.values.max
    best_cards = cards_without_joker.select { |card, count| count == max_value }

    @best_card = best_cards.keys.max
  end
end
