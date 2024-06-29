# frozen_string_literal: true

class Node
  attr_reader :label, :left, :right

  def initialize(label:, left:, right:)
    @label = label
    @left = left
    @right = right
  end

  def populate_with_children(from:)
    @left = from[left]
    @right = from[right]
  end
end
