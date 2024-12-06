# frozen_string_literal: true

require "matrix"

class Guard
  attr_accessor :breadcrumbs
  private attr_accessor :position, :direction

  def place(position:, direction:)
    @breadcrumbs = []
    @teleports = {}
    @position, @direction = position, direction
  end

  def tour!(map:)
    patrol(map:) until toured?
    self
  end

  def move(map:)
    self.position = position + direction
    map.mark(position:, direction:)
    self
  end

  def turn_right
    self.direction = Vector[direction[1], -direction[0]]
    self
  end

  private

  def patrol(map:)
    map.reach(guard: self, position: position + direction)
    self
  end

  def toured?
    breadcrumbs.any?
  end
end
