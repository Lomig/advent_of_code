# frozen_string_literal: true

require "matrix"

class Warehouse
  DIRECTIONS = {
    top: Vector[-1, 0],
    bottom: Vector[1, 0],
    left: Vector[0, -1],
    right: Vector[0, 1]
  }.freeze

  private attr_reader :locations

  def initialize
    @locations = {}
  end

  def []=(row, column, location)
    locations[Vector[row, column]] = location
  end

  def boxes = locations.values.select { |location| location.is_a?(Box) }

  def crates = locations.values.select { |location| location.is_a?(LeftCrate) }

  def neighbour(coordinates:, direction:)
    locations[coordinates + DIRECTIONS[direction]]
  end

  def move(coordinates:, direction:)
    location = locations[coordinates]

    locations_to_move = Set.new
    queue = [location]

    while (current_location = queue.shift)
      linked_locations = current_location.moving_parts
      locations_to_move.merge(linked_locations)

      linked_locations.each do |linked_location|
        neighbour = neighbour(coordinates: linked_location.coordinates, direction:)
        next unless neighbour
        return nil unless neighbour.movable?

        queue << neighbour unless locations_to_move.include?(neighbour)
      end
    end

    remove_locations(locations_to_move)
    put_back_locations(locations_to_move, direction:)
  end

  def remove_locations(locations_to_move)
    locations_to_move.each { |location| locations.delete(location.coordinates) }
  end

  def put_back_locations(locations_to_move, direction:)
    locations_to_move.each do |location|
      new_coordinates = location.coordinates + DIRECTIONS[direction]
      location.coordinates = new_coordinates
      locations[new_coordinates] = location
    end
  end

  def robot
    @robot ||= locations.values.find { |location| location.is_a?(Robot) }
  end
end
