# frozen_string_literal: true

class Robot
  @moves = 0

  MAX_ROWS = 103
  MAX_COLS = 101

  attr_reader :x, :y, :moves

  def initialize(x, y, vx, vy)
    @x, @y = x, y
    @vx, @vy = vx, vy
    @moves = 0
  end

  def move(t = 1)
    @moves += t

    @x = (@x + @vx * t) % MAX_COLS
    @y = (@y + @vy * t) % MAX_ROWS

    self
  end

  def quadrant
    return :up_left if @x < MAX_COLS / 2 && @y < MAX_ROWS / 2
    return :up_right if @x > MAX_COLS / 2 && @y < MAX_ROWS / 2
    return :bottom_left if @x < MAX_COLS / 2 && @y > MAX_ROWS / 2
    return :bottom_right if @x > MAX_COLS / 2 && @y > MAX_ROWS / 2

    :center
  end
end
