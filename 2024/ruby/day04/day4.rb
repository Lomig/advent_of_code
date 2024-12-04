# frozen_string_literal: true

require_relative "../aoc"

class Day4 < AoC
  input_as :matrix

  REGEXP = /XMAS/

  def result1
    horizontal_xmas + vertical_xmas + downward_diagonals_xmas + upward_diagonals_xmas
  end

  def result2
    input.each_with_index.sum do |letter, row, col|
      next 0 if row == 0 || col == 0
      next 0 if row == input.row_size - 1 || col == input.column_size - 1
      next 0 unless letter == ?A

      upward_cross_count(row, col) * downward_cross_count(row, col)
    end
  end

  private

  def upward_cross_count(row, col)
    return 1 if input[row - 1, col - 1] == ?M && input[row + 1, col + 1] == ?S
    return 1 if input[row - 1, col - 1] == ?S && input[row + 1, col + 1] == ?M

    0
  end

  def downward_cross_count(row, col)
    return 1 if input[row - 1, col + 1] == ?M && input[row + 1, col - 1] == ?S
    return 1 if input[row - 1, col + 1] == ?S && input[row + 1, col - 1] == ?M

    0
  end

  def horizontal_xmas
    input.row_vectors.sum do |row|
      string = row.to_a.join

      (string.scan(REGEXP) + string.reverse.scan(REGEXP)).count
    end
  end

  def vertical_xmas
    input.column_vectors.sum do |column|
      string = column.to_a.join

      (string.scan(REGEXP) + string.reverse.scan(REGEXP)).count
    end
  end

  def downward_diagonals_xmas
    downward_diagonals.sum do |diagonal|
      string = diagonal.join

      (string.scan(REGEXP) + string.reverse.scan(REGEXP)).count
    end
  end

  def upward_diagonals_xmas
    upward_diagonals.sum do |diagonal|
      string = diagonal.join

      (string.scan(REGEXP) + string.reverse.scan(REGEXP)).count
    end
  end

  # We can get diagonals by padding the matrix with nils,
  # then transposing it and then removing the nils.
  # 1 2 3    | | |1|2|3|
  # 4 5 6 => | |4|5|6| | => [[7],[4,8],[1,5,9],[2,6],[3]]
  # 7 8 9    |7|8|9| | |
  def downward_diagonals
    # PADDING_ARRAY: [[], [nil], [nil, nil]]
    # PADDING_ARRAY.reverse: [[nil, nil], [nil], []]

    # [nil, nil],[1, 2, 3]
    # [nil], [4, 5, 6]
    # [], [7, 8|, 9]
    left_padded_matrix = padding_array.reverse.zip(input.to_a)

    # | | |1|2|3|
    # | |4|5|6| |
    # |7|8|9| | |
    right_padded_matrix = left_padded_matrix.zip(padding_array).map(&:flatten)


    right_padded_matrix.transpose.map(&:compact)
  end

  # Upward diagonals are built the same way,
  # just exchanging the transposed/non-transposed padding array
  def upward_diagonals
    padding_array
      .zip(input.to_a)
      .zip(padding_array.reverse)
      .map(&:flatten)
      .transpose
      .map(&:compact)
  end

  def padding_array
    @padding_array ||= Array.new(input.row_size) { |i| [nil] * i }
  end
end
