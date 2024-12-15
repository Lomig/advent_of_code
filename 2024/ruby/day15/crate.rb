# frozen_string_literal: true

require_relative "location"

class Crate < Location
  def moving_parts = [self, twin]
end

class LeftCrate < Crate
  def twin
    warehouse.neighbour(coordinates:, direction: :right)
  end
end

class RightCrate < Crate
  def twin
    warehouse.neighbour(coordinates:, direction: :left)
  end
end
