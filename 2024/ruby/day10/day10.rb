# frozen_string_literal: true

require_relative "../aoc"
require_relative "node"

class Day10 < AoC
  input_as :matrix

  def result1 = trailheads.sum(&method(:score))

  def result2 = trailheads.sum(&method(:rating))

  private

  def score(node) = trails(node).uniq.count

  def rating(node) = trails(node).count

  def trails(node)
    summits = []

    queue = [node]

    while queue.any?
      current_node = queue.pop
      next (summits << current_node) if current_node.height == 9

      current_node.neighbours.each do |neighbour|
        next if neighbour.height - current_node.height != 1

        queue << neighbour
      end
    end

    summits
  end

  def trailheads
    nodes = {}
    trailheads = []

    input.each_with_index do |height, row, column|
      next if height == "."

      height = height.to_i

      node = Node.new(height:)
      nodes[[row, column]] = node

      trailheads << node if height.zero?
    end

    set_neighbourhood(nodes)
    trailheads
  end

  def set_neighbourhood(nodes)
    nodes.each do |(row, column), node|
      node.add_neighbour(nodes[[row - 1, column]])
      node.add_neighbour(nodes[[row + 1, column]])
      node.add_neighbour(nodes[[row, column - 1]])
      node.add_neighbour(nodes[[row, column + 1]])
    end
  end
end
