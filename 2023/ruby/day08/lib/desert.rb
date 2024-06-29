# frozen_string_literal: true

class Desert
  private attr_reader :nodes, :directions, :ghost_starts, :ghost_finishes

  def initialize(nodes:, directions:)
    @nodes = nodes
    @directions = directions

    @start = nodes["AAA"]
    @finish = nodes["ZZZ"]

    @ghost_starts = nodes.select { |label, _| label.end_with?("A") }.values
    @ghost_finishes = nodes.select { |label, _| label.end_with?("Z") }.values
  end

  def path_length(start: @start, finish: @finish, directions: @directions.cycle)
    length = 0
    current_node = start

    loop do
      return length if Array(finish).include?(current_node)

      length += 1
      current_node = current_node.send(directions.next)
    end
  end

  def ghostly_path_length
    ghost_starts.inject(1) do |result, start|
      result.lcm(path_length(start:, finish: ghost_finishes, directions: directions.cycle))
    end
  end
end
