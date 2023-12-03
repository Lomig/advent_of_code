# frozen_string_literal: true

require_relative "generic_part"
require_relative "mechanism"
require_relative "gear"

module Parts
  module Factory
    extend self

    def create_part(schematic:, element:, row:, column:)
      part_type(element).new(schematic:, element:, row:, column:)
    end

    private

    def part_type(element)
      case element
      when /\d/ then Mechanism
      when /\*/ then Gear
      else GenericPart
      end
    end
  end
end
