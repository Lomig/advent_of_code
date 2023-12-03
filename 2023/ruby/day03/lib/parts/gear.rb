# frozen_string_literal: true

require_relative "generic_part"

module Parts
  class Gear < GenericPart
    def power
      schematic
        .neighbours(self)
        .select { |neigbour| neigbour.serial_number > 0 }
        .tap { |connected_mechanisms| return 0 unless connected_mechanisms.count == 2 }
        .inject(1) { |result, connected_mechanism| result * connected_mechanism.serial_number }
    end
  end
end
