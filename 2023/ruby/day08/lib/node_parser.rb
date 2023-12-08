# frozen_string_literal: true

require_relative "node"

module NodeParser
  extend self

  DIRECTIONS = {
    "R" => :right,
    "L" => :left
  }.freeze

  NODE_REGEXP = /(?<node>\w+)\W+(?<left>\w+)\W+(?<right>\w+)/

  def parse(input)
    {
      directions: directions(input.shift),
      nodes: nodes(input)
    }
  end

  private

  def directions(raw_directions)
    raw_directions
      .chars
      .map { |raw_direction| DIRECTIONS[raw_direction] }
  end

  def nodes(raw_nodes)
    node_list = node_list(raw_nodes)

    node_list.each { |_, node| node.populate_with_children(from: node_list) }
  end

  def node_list(raw_nodes)
    raw_nodes.each_with_object({}) do |raw_node, node_list|
      next if raw_node.empty?

      node_matcher = raw_node.match(NODE_REGEXP)
      node_list[node_matcher[:node]] = Node.new(label: node_matcher[:node], left: node_matcher[:left], right: node_matcher[:right])
    end
  end
end
