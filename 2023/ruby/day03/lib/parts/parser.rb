# frozen_string_literal: true

require_relative "factory"

module Parts
  class Parser
    private attr_reader :matrix, :schematic

    def initialize(matrix:, schematic:)
      @matrix = matrix
      @schematic = schematic
    end

    def parse
      matrix
        .each_with_index
        .with_object([], &get_parts)
        .compact
    end

    private

    def get_parts = lambda do |(element, row, column), parts|
      next parts << nil if element == "."

      last_part = parts.last
      new_part = Factory.create_part(schematic:, element:, row:, column:)

      parts << new_part unless last_part&.fuse!(new_part)
    end
  end
end
