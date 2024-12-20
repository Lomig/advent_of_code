# frozen_string_literal: true

class Node
  attr_reader :position
  attr_accessor :distance, :neighbours, :path

  def initialize(position:)
    @position = position
    @neighbours = []
    @distance = Float::INFINITY
    @path = []
  end

  def wall? = false

  def reset_distance
    @distance = Float::INFINITY
    @path = []
  end
end

class StartingNode < Node
  def distance = 0

  def path = [self]
end

class Wall < Node
  def wall? = true
end

NODE_TYPES = {
  "#" => Wall,
  "." => Node,
  "S" => StartingNode,
  "E" => Node
}.freeze

def Node.[](element, position) = NODE_TYPES[element].new(position:)
