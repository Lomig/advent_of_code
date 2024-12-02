# frozen_string_literal: true

require_relative "../aoc"

class Day2 < AoC
  input_as :array, formatter: ->(line) { line.split(" ").map(&:to_i) }

  def result1 = input.count(&method(:safe?))

  def result2 = input.count(&method(:dampened_safe?))

  private

  def safe?(report)
    report
      .each_cons(2)
      .inject([true, true]) do |(desc_safety, asc_safety), (reading1, reading2)|
      return false unless desc_safety || asc_safety
      [
        desc_safety && (reading1 > reading2) && (reading1 - reading2) <= 3,
        asc_safety && (reading1 < reading2) && (reading2 - reading1) <= 3
      ]
    end.any?
  end

  def dampened_safe?(report)
    return true if safe?(report)

    report.count.times do |i|
      dampened_report = report.clone.tap { |r| r.delete_at(i) }
      return true if safe?(dampened_report)
    end

    false
  end
end

