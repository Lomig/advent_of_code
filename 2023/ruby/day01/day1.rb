# frozen_string_literal: true

require_relative "../aoc"

class Day1 < AoC
  WORDS = %w[zero one two three four five six seven eight nine].freeze

  DIGIT_NUMBERS_REGEXP = /\d/
  DIGIT_LETTER_NUMBERS_REGEXP = Regexp.new("(?=(#{WORDS.join("|")}|\\d))")

  def result1
    @regexp = DIGIT_NUMBERS_REGEXP
    compute
  end

  def result2
    @regexp = DIGIT_LETTER_NUMBERS_REGEXP
    compute
  end

  private

  def compute = input.sum(&first_and_last_digit)

  def first_and_last_digit = lambda do |string|
    numbers = string.scan(@regexp).flatten

    "#{convert_to_digits(numbers.first)}#{convert_to_digits(numbers.last)}".to_i
  end

  def convert_to_digits(number)
    return number.to_i if Integer(number, exception: false)

    WORDS.index(number)
  end
end
