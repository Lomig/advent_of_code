require_relative "../aoc"

require_relative "computer"

class Day17 < AoC
  def result1 = parse_input && new_computer.run

  def result2
    parse_input

    @data.reverse.reduce(Set.new << 0) do |candidates, output|
      candidates.reduce(Set.new) do |next_candidates, base|
        next_candidates.merge(register_value_candidates(output:, base:))
      end
    end.min
  end

  private

  def output_digit(a)
    temp = (a % 8) ^ 1

    ((temp ^ (a >> temp)) ^ 6) % 8
  end

  def register_value_candidates(output:, base:)
    base <<= 3

    8.times.with_object(Set.new) do |n, candidates|
      value = base + n

      candidates << value if output_digit(value) == output
    end
  end

  def new_computer
    Computer
      .new(register_a: @register_a, register_b: @register_b, register_c: @register_c)
      .feed(@data)
  end

  def parse_input
    @register_a = input[0].delete_prefix("Register A: ").to_i
    @register_b = input[1].delete_prefix("Register B: ").to_i
    @register_c = input[2].delete_prefix("Register C: ").to_i

    @data = input[4].delete_prefix("Program: ").split(",").map(&:to_i)
  end
end
