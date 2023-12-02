# frozen_string_literal: true

class Game
  private attr_reader :id, :red_throws, :green_throws, :blue_throws

  def initialize(id:, throws:)
    @id = id
    @red_throws, @green_throws, @blue_throws = throws.transpose
  end

  def possible_score = possible? ? id : 0

  def power = minimum_dice_set.inject(:*)

  private

  def possible?
    return false if red_throws.any? { |throw| throw > 12 }
    return false if green_throws.any? { |throw| throw > 13 }

    blue_throws.all? { |throw| throw <= 14 }
  end

  def minimum_dice_set = [red_throws.max, green_throws.max, blue_throws.max]
end
