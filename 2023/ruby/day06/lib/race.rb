# frozen_string_literal: true

require_relative "polynome"

class Race
  private attr_reader :time, :distance_to_beat, :polynome

  def initialize(race_data)
    @time, @distance_to_beat = race_data

    @polynome = Polynome.new(a: 1, b: -@time, c: @distance_to_beat)
  end

  def winning_move_count = polynome.integer_solutions_where_greater_than_zero
end
