# frozen_string_literal: true

require_relative "../aoc"

class Integer
  def concatenate(other) = (self.to_s + other.to_s).to_i
end


class Day7 < AoC
  OPERATORS = [:+, :*].freeze

  State = Data.define(:value, :members, :accumulator)

  def result1
    @operators = OPERATORS
    parsed_input.select(&method(:valid_equation?)).sum(&:value)
  end

  def result2
    @operators = OPERATORS + [:concatenate]
    parsed_input.select(&method(:valid_equation?)).sum(&:value)
  end

  private

  def valid_equation?(state)
    queue = [state]

    until queue.empty?
      current_state = queue.shift
      return true if current_state.accumulator == current_state.value
      next if current_state.accumulator > current_state.value
      next if current_state.members.empty?

      @operators.each do |operator|
        new_members = current_state.members[1..]
        new_accumulator = current_state.accumulator.send(operator, current_state.members[0])
        queue << State[current_state.value, new_members, new_accumulator]
      end
    end
    false
  end

  def parsed_input
    input.map do |line|
      value, raw_members = line.split(": ")
      members = raw_members.split.map(&:to_i)
      State[value.to_i, members[1..], members[0]]
    end
  end
end
