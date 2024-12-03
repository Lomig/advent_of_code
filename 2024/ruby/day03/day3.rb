# frozen_string_literal: true

require_relative "../aoc"

class Day3 < AoC
  input_as :raw

  REGEXP = /mul\((\d{1,3}),(\d{1,3})\)/
  REGEXP2 = /(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))/


  def result1
    input
      .scan(REGEXP)
      .sum { |(a, b)| a.to_i * b.to_i }
  end

  def result2
    processing = true

    input
      .scan(REGEXP2)
      .sum do |(op, a, b)|
      next (processing = true) && 0 if op == "do()"
      next (processing = false) || 0 if op == "don't()"
      next 0 unless processing

      a.to_i * b.to_i
    end
  end
end
