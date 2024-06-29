# frozen_string_literal: true

require_relative "../aoc"

class Day9 < AoC
  input_as :array, formatter: ->(line) { line.scan(/-?\d+/).map(&:to_i) }

  def result1 = OasisReport.new(input).extrapolate

  def result2 = OasisReport.new(input.map(&:reverse)).extrapolate
end

class OasisReport
  private attr_reader :readings

  def initialize(readings)
    @readings = readings.compact
  end

  def extrapolate = readings.sum(&method(:find_increase))

  private

  def find_increase(reading)
    return 0 if reading.all?(0)

    reduced_reading = reading.each_cons(2).map { |first, last| last - first }
    reading.last + find_increase(reduced_reading)
  end
end
