# frozen_string_literal: true

require_relative "../aoc"

class Day1 < AoC
  def result1
    id_lists
      .map(&:sort)
      .transpose
      .sum { |(id1, id2)| (id1 - id2).abs }
  end

  def result2
    id_lists.then do |(list1, list2)|
      list1.sum { |id| id * list2.count(id) }
    end
  end

  private

  def id_lists = input.map { |line| line.split("   ").map(&:to_i) }.transpose
end
