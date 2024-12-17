# frozen_string_literal: true

class Computer
  class Halt < StandardError; end

  INSTRUCTION_SET = %i[
    adv bxl bst jnz bxc out bvv cdv
  ].freeze

  def initialize(register_a: 0, register_b: 0, register_c: 0)
    @register_a, @register_b, @register_c = register_a, register_b, register_c
    @input = []
    @output = []
    @pointer = 0
  end

  def feed(input)
    @input = input
    self
  end

  def run
    loop { send(INSTRUCTION_SET[next_input]) }
  rescue Halt
    @output.join(",")
  end

  private

  def next_input
    raise Halt if @pointer >= @input.size

    input = @input[@pointer]
    @pointer += 1
    input
  end

  def combo(operand)
    [
      0, 1, 2, 3, @register_a, @register_b, @register_c, :unused
    ][operand]
  end

  def adv
    operand = combo(next_input)
    @register_a /= (2**operand)
  end

  def bxl
    operand = next_input
    @register_b ^= operand
  end

  def bst
    operand = combo(next_input)
    @register_b = operand % 8
  end

  def jnz
    operand = next_input
    return if @register_a.zero?

    @pointer = operand
  end

  def bxc
    next_input
    @register_b ^= @register_c
  end

  def out
    operand = combo(next_input)
    @output << operand % 8
  end

  def bdv
    operand = combo(next_input)
    @register_b = @register_a / (2**operand)
  end

  def cdv
    operand = combo(next_input)
    @register_c = @register_a / (2**operand)
  end
end
