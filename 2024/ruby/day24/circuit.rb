# frozen_string_literal: true

class Circuit
  def initialize
    @wires = {}
    @gates = []
    @initial_active_wires = []
  end

  def output
    100.times.reduce("") do |acc, i|
      wire = @wires["z#{i.to_s.rjust(2, "0")}"]
      next acc unless wire

      "#{wire.state}#{acc}"
    end.to_i(2)
  end

  def faulty_wires
    @gates.select do |gate|
      inputs, output = gate.inputs, gate.out
      (!gate.is_a?(Or) && output.max_z?) ||
        (!gate.is_a?(Xor) && output.main_output? && !output.max_z?) ||
        (gate.is_a?(Xor) && inputs.all?(&:main_input?) && output.main_output?) ||
        (gate.is_a?(Xor) && inputs.none?(&:main_input?) && !output.main_output?) ||
        (gate.is_a?(And) && inputs.none? { | wire| wire.name == "x00" } && output.input_of?(Xor)) ||
        (gate.is_a?(Xor) && inputs.none? { | wire| wire.name == "x00" } && output.input_of?(Or))
    end.map(&:out)
  end

  def activate
    active_wires = @initial_active_wires.dup

    queue = @initial_active_wires.dup
    used_wires = []

    while (current_wire = queue.shift)
      used_wires << current_wire

      current_wire
        .active_gates(active_wires)
        .map(&:activate) => activated_wires

      active_wires |= activated_wires
      queue.push(*(activated_wires - used_wires))
    end

    self
  end

  def add_wire(wire)
    return @wires[wire.name] if @wires[wire.name]

    @wires[wire.name] = wire
  end

  def list_active_wires(active_wires)
    @initial_active_wires = active_wires
  end

  def add_gate(gate) = @gates << gate

  def mark_z_max(z_max)
    @wires["z#{z_max.to_s.rjust(2, "0")}"].max_z!
    self
  end
end
