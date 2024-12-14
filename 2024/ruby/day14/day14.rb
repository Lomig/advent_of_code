# frozen_string_literal: true

require_relative "../aoc"
require_relative "robot"

class Day14 < AoC
  REGEXP = /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/

  input_as :array, formatter: ->(line) {
    line
      .scan(REGEXP)
      .flatten
      .map(&:to_i)
      .then { |x, y, vx, vy| Robot.new(x, y, vx, vy) }
  }

  def result1
    input
      .each { |robot| robot.move(100) }
      .group_by(&:quadrant)
      .reduce(1) { |safety, (quadrant, robots)| safety * ((quadrant == :center) ? 1 : robots.count) }
  end

  def result2
    loop do
      input.each(&:move)
      break input.first.moves if input.count == input.uniq { |robot| [robot.x, robot.y] }.count
    end
  end
end
