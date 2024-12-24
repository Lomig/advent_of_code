# frozen_string_literal: true

class Wire
  attr_accessor :state
  attr_reader :name

  def initialize(name, state = nil)
    @name, @state = name, state
    @gates = Hash.new { |h, k| h[k] = [] }
  end

  def active_gates(active_wires)
    @gates
      .select { |wire, _| active_wires.include?(wire) }
      .values
      .flatten
  end

  def main_input? = @name[0] == "x" || @name[0] == "y"

  def main_output? = @name[0] == "z"

  def max_z? = main_output? && @is_max

  def max_z!
    return unless main_output?

    @is_max = true
  end

  def input_of?(gate_class) = @gates.values.flatten.any? { |gate| gate.is_a?(gate_class) }

  def add_gate(gate)
    complementary_wire = (gate.in1 == self) ? gate.in2 : gate.in1
    @gates[complementary_wire] << gate
  end
end
