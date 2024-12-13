# frozen_string_literal: true

require_relative "../aoc"

class Day13 < AoC
  NUMBER_REGEXP = /(\d+)/
  # custom_input <<~TXT
  #   Button A: X+94, Y+34
  #   Button B: X+22, Y+67
  #   Prize: X=8400, Y=5400
  #
  #   Button A: X+26, Y+66
  #   Button B: X+67, Y+21
  #   Prize: X=12748, Y=12176
  #
  #   Button A: X+17, Y+86
  #   Button B: X+84, Y+37
  #   Prize: X=7870, Y=6450
  #
  #   Button A: X+69, Y+23
  #   Button B: X+27, Y+71
  #   Prize: X=18641, Y=10279
  # TXT

  def result1
    parse_claw_machines
      .map(&method(:resolve))
      .sum(&method(:pay))
  end

  def result2
    parse_claw_machines
      .map(&method(:increase_prize_distance))
      .map(&method(:resolve))
      .sum(&method(:pay))
  end

  private

  def pay((a_push, b_push))

    a_push * 3 + b_push
  end

  def resolve((buttons, prize))
    rational_solution = (buttons.inverse * prize)
    return [0, 0] if rational_solution.any? { |push| push.denominator != 1 }

    rational_solution
      .map(&:to_i)
      .to_a
      .flatten
  end

  def increase_prize_distance(equation)
    equation[1] = equation[1] + Matrix.build(2, 1) { 10_000_000_000_000 }
    equation
  end

  def parse_claw_machines
    input
      .reject(&:empty?)
      .each_slice(3)
      .map do |button_a, button_b, prize|
      parsed_a = button_a.scan(NUMBER_REGEXP).flatten.map(&:to_i)
      parsed_b = button_b.scan(NUMBER_REGEXP).flatten.map(&:to_i)
      equations = [parsed_a, parsed_b].transpose
      parsed_prize = prize.scan(NUMBER_REGEXP).map { _1.map(&:to_i) }

      [
        Matrix[*equations],
        Matrix[*parsed_prize]
      ]
    end
  end
end
