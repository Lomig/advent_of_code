# frozen_string_literal: true

require_relative "location"

class Robot < Location
  def move(direction:)
    warehouse.move(coordinates:, direction:)
  end
end
