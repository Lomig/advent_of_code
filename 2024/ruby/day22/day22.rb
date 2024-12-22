# frozen_string_literal: true

require_relative "../aoc"
require_relative "monkey_rand"

class Day22 < AoC
  def result1
    input.sum { |seed| MonkeyRand.new(seed.to_i).rand(2_000) }
  end

  def result2
    secrets = input.map { |seed| MonkeyRand.new(seed.to_i).list(2_000) }
    diffs = Hash.new { |h, k| h[k] = 0 }

    secrets.each do |list|
      unavailable_diffs = {}

      list.each_cons(5) do |(p1, p2, p3, p4, p5)|
        dx1 = p2 - p1
        dx2 = p3 - p2
        dx3 = p4 - p3
        dx4 = p5 - p4

        unless unavailable_diffs[[dx1, dx2, dx3, dx4]]
          diffs[[dx1, dx2, dx3, dx4]] += p5
          unavailable_diffs[[dx1, dx2, dx3, dx4]] = true
        end
      end
    end

    diffs.values.max
  end
end
