# frozen_string_literal: true

class Gate
  attr_reader :in1, :in2, :out

  def initialize(in1, in2, out)
    @in1 = in1
    @in2 = in2
    @out = out

    @in1.add_gate(self)
    @in2.add_gate(self)
  end

  def activate
    @out.state = @in1.state.send(self.class::OPERATOR, @in2.state)

    @out
  end

  def inputs = [@in1, @in2]
end

class And < Gate
  OPERATOR = :&
end

class Or < Gate
  OPERATOR = :|
end

class Xor < Gate
  OPERATOR = :^
end

def Gate.[](in1, in2, gate_type, out)
  Object.const_get(gate_type.capitalize).new(in1, in2, out)
end
