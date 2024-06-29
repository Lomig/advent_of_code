# frozen_string_literal: true

class Card
  include Comparable

  @card_values = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"].freeze

  attr_reader :label, :value

  def initialize(card)
    @label = card
    @value = self.class.card_values.index(card)
  end

  def <=>(other)
    value <=> other.value
  end

  def eql?(other)
    return false unless other.is_a?(Card)

    label == other.label
  end
  alias_method :==, :eql?

  def hash = label.hash

  def self.card_values = @card_values
end

class CardWithJoker < Card
  @card_values = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"].freeze
end
