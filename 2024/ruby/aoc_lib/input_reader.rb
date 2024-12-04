# frozen_string_literal: true

require "matrix"

class RawInputReader
  private attr_reader :input, :file_name, :formatter

  def initialize(input:, file_name:, formatter:)
    @input = input
    @file_name = file_name
    @formatter = formatter
  end

  def read
    if formatter.is_a?(Proc)
      formatter.call(raw_input)
    else
      raw_input.send(formatter)
    end
  end

  def raw_input = input || File.read(file_name)
end

class ArrayReader < RawInputReader
  def read = lines.map(&formatter)

  def lines = input&.split("\n") || File.readlines(file_name, chomp: true)
end

class MatrixReader < RawInputReader
  private attr_reader :row, :column

  def initialize(input:, file_name:, formatter:)
    @row = @column = 0
    super
  end

  def read
    (input || File.open(file_name))
      .each_char
      .with_object([[]], &populate_matrix)
      .then { |matrix| Matrix[*matrix] }
  end

  def populate_matrix = lambda { |char, matrix|
    if char == "\n"
      increase_row
      reset_column
      matrix << []
      next
    end

    matrix.last << if formatter.is_a?(Proc)
      formatter.call(char, row, column)
    else
      char.send(formatter)
    end

    increase_column
  }

  def increase_row
    @row += 1
  end

  def increase_column
    @column += 1
  end

  def reset_column
    @column = 0
  end
end

class InputReader
  INPUT_STRUCTURES = {
    raw: ::RawInputReader,
    array: ::ArrayReader,
    matrix: ::MatrixReader
  }.freeze

  private attr_reader :input

  def self.new(input:, file_name:, structure:, formatter:)
    INPUT_STRUCTURES[structure].new(input:, file_name:, formatter:)
  end
end
