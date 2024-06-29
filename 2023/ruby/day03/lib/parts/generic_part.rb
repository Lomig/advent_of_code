# frozen_string_literal: true

module Parts
  class GenericPart
    attr_reader :row, :raw_serial, :last_column
    private attr_reader :schematic, :first_column

    def initialize(schematic:, element:, row: nil, column: nil)
      @schematic = schematic
      @raw_serial = element.to_s
      @row = row
      @first_column = column
      @last_column = column
    end

    def range = (first_column..last_column).to_a

    def neighbouring_range = (first_column - 1..last_column + 1).to_a

    def serial_number = 0

    def power = 0

    def fuse!(other) = false
  end
end
