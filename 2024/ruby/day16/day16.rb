require_relative "../aoc"

require_relative "maze"

class Day16 < AoC
  input_as :matrix

  def result1 = maze.race!.first

  def result2 = maze.with_scenary.race!.last

  private

  def maze
    input.each_with_index.with_object(Maze.new) do |(cell, row, column), maze|
      maze.add_element(row, column, cell)
    end
  end
end
