# frozen_string_literal: true

module CardParser
  extend self

  def parse(raw_card)
    raw_card
      .split(/\s+/)
      .each_with_object([], &get_card_values)
  end

  private

  def get_card_values = lambda do |value, card_values|
    if (card_id_matcher = value.match(/(\d+):/))
      card_values << card_id_matcher[0].to_i
      next card_values << []
    end

    next card_values << [] if value == "|"
    next unless (casted_value = Integer(value, exception: false))

    card_values.last << casted_value
  end
end
