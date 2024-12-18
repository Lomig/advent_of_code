# frozen_string_literal: true

Node = Data.define(:coordinates, :path)

class MemorySpace
  DIRECTIONS = [1i, -1i, 1, -1].freeze

  def initialize
    @start = Complex(0, 0)
    @finish = Complex(70, -70)
    @corrupted_spaces = Set.new
  end

  def traverse!
    queue = [Node[@start, []]]
    visited_nodes = @corrupted_spaces.dup

    shortest_path_size = Float::INFINITY
    shortest_path = Set.new

    while (current_node = queue.shift)
      coordinates, path = current_node.deconstruct
      next if path.count >= shortest_path_size

      if coordinates == @finish
        shortest_path = path
        shortest_path_size = shortest_path.count
        next
      end

      DIRECTIONS.each do |direction|
        new_coordinates = coordinates + direction
        next if new_coordinates.real.negative? || new_coordinates.real > @finish.real
        next if new_coordinates.imaginary.positive? || new_coordinates.imaginary < @finish.imaginary
        next if visited_nodes.include?(new_coordinates)

        visited_nodes << new_coordinates
        queue << Node[new_coordinates, path + [coordinates]]
      end
    end

    shortest_path
  end

  def <<(coordinates)
    @corrupted_spaces << coordinates
  end
end
