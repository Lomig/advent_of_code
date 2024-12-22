# frozen_string_literal: true

class MonkeyRand
  attr_reader :seed

  def initialize(seed)
    @seed = seed
  end

  def rand(times = 1)
    times.times do
      step_1
      step_2
      step_3
    end

    @seed
  end

  def list(times = 1)
    (0...times).each_with_object([@seed % 10]) do |_, list|
      step_1
      step_2
      step_3
      list << @seed % 10
    end
  end

  def step_1
    @seed = ((@seed << 6) ^ @seed) & 0b111111111111111111111111
  end

  def step_2
    @seed = ((@seed >> 5) ^ @seed) & 0b111111111111111111111111
  end

  def step_3
    @seed = ((@seed << 11) ^ @seed) & 0b111111111111111111111111
  end
end
