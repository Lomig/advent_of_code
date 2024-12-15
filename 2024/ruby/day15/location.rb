# frozen_string_literal: true

require "matrix"

class Location
  LOCATIONS = {
    "#" => "Wall",
    "O" => "Box",
    "@" => "Robot",
    "[" => "LeftCrate",
    "]" => "RightCrate"
  }.freeze

  attr_accessor :coordinates
  private attr_reader :warehouse

  def initialize(coordinates:, warehouse:)
    @coordinates, @warehouse = coordinates, warehouse
  end

  def movable? = true

  def moving_parts = [self]

  def gps_value = coordinates[0] * 100 + coordinates[1]
end

def Location.[](symbol, row, column, warehouse)
  return if symbol == "."

  Object
    .const_get(Location::LOCATIONS[symbol])
    .new(coordinates: Vector[row, column], warehouse:)
end
