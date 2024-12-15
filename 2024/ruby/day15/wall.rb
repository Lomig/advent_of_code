# frozen_string_literal: true

require_relative "location"

class Wall < Location
  def movable? = false
end
