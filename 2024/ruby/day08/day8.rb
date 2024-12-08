# frozen_string_literal: true

require_relative "../aoc"

class Day8 < AoC
  input_as :matrix

  def result1
    @with_resonnance = false
    count_antinodes
  end

  def result2
    @with_resonnance = true
    count_antinodes
  end

  private

  def count_antinodes
    @antinodes = Set.new

    antennas_per_frequency.each do |(_, antennas)|
      antennas.each { |antenna| find_paired_antennas_and_get_antinodes(antenna:, antennas:) }
    end

    @antinodes.count
  end

  def find_paired_antennas_and_get_antinodes(antenna:, antennas:)
    row, col = antenna
    antennas.each { |(twin_row, twin_col)| get_antinodes(row:, col:, twin_row:, twin_col:) }
  end

  def get_antinodes(row:, col:, twin_row:, twin_col:)
    return if row == twin_row && col == twin_col

    @antinodes << [twin_row, twin_col] if @with_resonnance

    loop do
      antinode_row = twin_row - 2 * (twin_row - row)
      antinode_col = twin_col - 2 * (twin_col - col)
      break unless within_bounds?(antinode_row, antinode_col)

      @antinodes << [antinode_row, antinode_col]
      break unless @with_resonnance

      twin_row, twin_col = row, col
      row, col = antinode_row, antinode_col
    end
  end

  def within_bounds?(row, col)
    row >= 0 && row < input.row_count && col >= 0 && col < input.column_count
  end

  def antennas_per_frequency
    input
      .each_with_index
      .with_object(Hash.new { |hash, key| hash[key] = Set.new }) do |(node, row, col), antennas|
      next if node == "."

      antennas[node] << [row, col]
    end
  end
end
