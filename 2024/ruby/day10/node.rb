# frozen_string_literal: true

class Node
  attr_reader :neighbours, :height

  def initialize(height:)
    @height = height
    @neighbours = []
  end

  def add_neighbour(node)
    return unless node

    @neighbours << node
  end
end
