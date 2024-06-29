# frozen_string_literal: true

require_relative "../aoc"

require_relative "lib/desert"
require_relative "lib/node_parser"

class Day8 < AoC
  def result1
    Desert.new(**NodeParser.parse(input)).path_length
  end

  def result2
    Desert.new(**NodeParser.parse(input)).ghostly_path_length
  end
end
