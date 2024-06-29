# frozen_string_literal: true

require_relative "generic_part"

module Parts
  class Mechanism < GenericPart
    def serial_number
      return @serial_number if defined?(@serial_number)

      @serial_number = valid? ? raw_serial.to_i : 0
    end

    def fuse!(other)
      return false unless instance_of?(other.class)
      return false unless row == other.row

      @last_column = other.last_column
      @raw_serial = raw_serial + other.raw_serial

      true
    end

    private

    def valid?
      schematic
        .neighbours(self)
        .reject { |neigbour| neigbour.is_a?(Mechanism) }
        .any?
    end
  end
end
