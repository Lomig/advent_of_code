# frozen_string_literal: true

require_relative "../aoc"

class Day1 < AoC
  current_day 01

  def result1
    id_lists
      .map(&:sort)
      .then { |(l1, l2)| l1.zip(l2).sum { |(i1, i2)| (i1 - i2).abs } }
  end


  def result2
    id_lists.then do |(list1, list2)|
      list1.sum { |id| id * list2.count(id) }
    end
  end

  private

  def id_lists = input.map { |line| line.split("   ").map(&:to_i) }.transpose
end
