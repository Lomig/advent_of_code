# frozen_string_literal: true

require_relative "../aoc"
require_relative "race_track"

class Day20 < AoC
  input_as :matrix

  def result1 = RaceTrack.new(input).best_cheating_candidates.count

  def result2 = RaceTrack.new(input).best_cheating_candidates(cheating_steps: 20).count
end
