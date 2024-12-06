# frozen_string_literal: true

class MapElement
  attr_accessor :position, :direction

  def initialize(position:, direction: nil)
    @position = position
    @direction = direction
  end
end

class Void < MapElement; end

class Obstacle < MapElement; end

class Breadcrumb < MapElement; end
