# frozen_string_literal: true

require_relative "../aoc"
require_relative "circuit"
require_relative "wire"
require_relative "gate"

class Day24 < AoC
  GATE_REGEX = /(?<wire1>\w+) (?<gate>\w+) (?<wire2>\w+) -> (?<wire3>\w+)/

  def result1 = circuit.activate.output

  def result2 = circuit.faulty_wires.map(&:name).sort.join(", ")

  def circuit
    z_max = 0
    circuit = Circuit.new

    active_wires = input
      .take_while { |line| line.include?(":") }
      .map do |line|
      wire_name, wire_state = line.split(": ")
      circuit.add_wire(Wire.new(wire_name, wire_state.to_i))
    end

    circuit.list_active_wires(active_wires)

    input[active_wires.count + 1..]
      .each do |line|
      match = GATE_REGEX.match(line)
      wire1 = circuit.add_wire(Wire.new(match[:wire1]))
      wire2 = circuit.add_wire(Wire.new(match[:wire2]))
      wire3 = circuit.add_wire(Wire.new(match[:wire3]))

      z_max = wire3.name[1..].to_i if wire3.main_output? && wire3.name[1..].to_i > z_max

      circuit.add_gate(Gate[wire1, wire2, match[:gate], wire3])
    end

    circuit.mark_z_max(z_max)
  end
end
