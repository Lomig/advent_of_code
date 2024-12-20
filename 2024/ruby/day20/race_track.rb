# frozen_string_literal: true

require_relative "node"

class RaceTrack
  def initialize(matrix)
    @track = track_from_matrix(matrix)
    set_neighbours
  end

  def best_cheating_candidates(cheating_steps: 2)
    race!

    @ending_node
      .path
      .flat_map { |node| cheat(node:, steps: cheating_steps) }
      .select { |saving| saving >= 100 }
  end

  private

  def cheat(node:, steps:)
    nodes_within_manhattan_distance(node:, steps:)
      .map { |(candidate, manhattan_distance)| candidate.distance - node.distance - manhattan_distance }
  end

  def nodes_within_manhattan_distance(node:, steps:)
    (-steps..steps).each_with_object(Set.new) do |x, nodes|
      (-steps..steps).each do |y|
        manhattan_distance = x.abs + y.abs
        next if manhattan_distance > steps

        neighbour = @track[node.position + Complex(x, y)]
        next unless neighbour
        next if neighbour.wall?

        nodes << [neighbour, manhattan_distance]
      end
    end
  end

  def race!
    queue = [@starting_node]

    while (current_node = queue.shift)
      current_node.neighbours.each do |neighbour|
        next if neighbour.wall?

        new_distance = current_node.distance + 1
        next if neighbour.distance <= new_distance

        neighbour.distance = new_distance
        neighbour.path = current_node.path + [neighbour]
        queue << neighbour
      end
    end
  end

  def track_from_matrix(matrix)
    matrix.each_with_index.with_object({}) do |(e, row, col), track|
      position = Complex(col, -row)
      track[position] = Node[e, position]

      @starting_node = track[position] if e == "S"
      @ending_node = track[position] if e == "E"
    end
  end

  def set_neighbours
    @track.each do |position, node|
      node.neighbours = [
        @track[position + 1],
        @track[position - 1],
        @track[position + 1i],
        @track[position - 1i]
      ].compact
    end
  end
end
