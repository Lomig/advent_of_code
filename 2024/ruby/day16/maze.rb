# frozen_string_literal: true

require "matrix"

Node = Data.define(:coordinates, :direction, :score, :path)

class Maze
  DIRECTION_VECTORS = {
    north: Vector[-1, 0],
    south: Vector[1, 0],
    east: Vector[0, 1],
    west: Vector[0, -1]
  }.freeze

  OPPOSITE_DIRECTIONS = {
    north: :south,
    south: :north,
    east: :west,
    west: :east
  }.freeze

  attr_reader(:scores)

  def initialize
    @scores = {}
  end

  def with_scenary
    @with_scenary = true
    self
  end

  def neighbouring_directions(node)
    DIRECTION_VECTORS
      .to_h { |direction, vector| [direction, node.coordinates + vector] }
      .select { |direction, coordinates| @scores[coordinates] && node.direction != OPPOSITE_DIRECTIONS[direction] }
  end

  def race!
    queue = [Node[coordinates: @start, direction: :east, score: 0, path: [@start]]]
    best_score = Float::INFINITY
    best_pathes = []

    while (current_node = queue.shift)
      coordinates, direction, score, path = current_node.deconstruct
      next if score > best_score

      if coordinates == @finish
        next best_pathes << path if @with_scenary && best_score == score

        best_score = score
        best_pathes = path
        next
      end

      neighbouring_directions(current_node).each do |new_direction, new_coordinates|
        new_score = score + ((direction == new_direction) ? 1 : 1_001)
        next if @scores[new_coordinates][new_direction] < new_score
        next if !@with_scenary && @scores[new_coordinates][new_direction] == new_score

        @scores[new_coordinates][new_direction] = new_score
        queue << Node[coordinates: new_coordinates, direction: new_direction, score: new_score, path: path + [new_coordinates]]
      end

    end
    [best_score, best_pathes.flatten.uniq.count]
  end

  def add_element(row, column, element)
    return if element == "#"

    coordinates = Vector[row, column]

    case element
    when "S" then @start = coordinates
    when "E" then @finish = coordinates
    end

    @scores[coordinates] = DIRECTION_VECTORS.to_h { |direction, _| [direction, Float::INFINITY] }
  end
end
