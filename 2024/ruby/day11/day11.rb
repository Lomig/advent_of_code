# frozen_string_literal: true

require_relative "../aoc"

class Day11 < AoC
  input_as :raw, formatter: ->(input) { input.split.map(&:to_i) }


  def result1 = blink(25)

  def result2 = blink(75)

  private

  def blink(blink_count)
    @stone_counts = {}
    input.sum { |stone| shift_stone_and_cache(stone:, blink_count:) }
  end

  def shift_stone_and_cache(stone:, blink_count:)
    return @stone_counts[[stone, blink_count]] if @stone_counts[[stone, blink_count]]
    return 1 if blink_count.zero?

    next_stones = Array(shift_stone(stone))

    @stone_counts[[stone, blink_count]] = next_stones.sum { |next_stone| shift_stone_and_cache(stone: next_stone, blink_count: blink_count - 1) }
  end

  def shift_stone(stone)
    return 1 if stone == 0

    stone_as_string = stone.to_s
    return cut_stone(stone_as_string) if stone_as_string.length.even?

    stone * 2024
  end

  def cut_stone(stone_string)
    middle_index = stone_string.length / 2
    [stone_string[...middle_index].to_i, stone_string[middle_index..].to_i]
  end
end
