# frozen_string_literal: true

class Crop
  attr_reader :kind, :perimeter, :row, :column
  attr_accessor :region
  private attr_reader :neighbours

  def initialize(kind, row, column)
    @kind, @row, @column = kind, row, column

    @neighbours = []
    @perimeter = 4
  end

  def add_neighbour(crop)
    return self unless crop

    @neighbours << crop
    self
  end

  def corners
    count = regional_neighbours.count
    # ...
    # .C. Crop is alone: 4 corners
    # ...
    return 4 if count.zero?

    # ...
    # .C. Crop has a single regional neighbour: 2 corners
    # .C.
    return 2 if count == 1

    # ...
    # CCC Crop has two aligned regional neighbours: 0 corners
    # ...
    return 0 if count == 2 && regional_neighbours_in_line?

    corners = 0
    # ...      ...
    # .CC  OR  .CC
    # .CC      .C.
    corners += 1 if count == 2

    # CCC
    # CAX Crop A is a corner cutter
    # CXX
    corners + corner_cutters
  end

  def enclose!
    @perimeter = 4 - regional_neighbours.count
    @region ||= Region.new(self)
  end

  def regional_neighbours_in_line?
    regional_neighbours.count { |neighbour| neighbour.row == row } == 2 ||
      regional_neighbours.count { |neighbour| neighbour.column == column } == 2
  end

  def regional_neighbours
    @regional_neighbours ||= neighbours.select { |neighbour| neighbour.kind == kind }
  end

  def alien_neighbours
    @alien_neighbours ||= neighbours.reject { |neighbour| neighbour.kind == kind }
  end

  def corner_cutters
    regional_neighbours.combination(2).count do |c1, c2|
      c1.alien_neighbours
        .intersection(c2.alien_neighbours)
        .any?
    end
  end

  def to_s
    "<Crop #{kind} (#{row}, #{column}, corners: #{corners})>"
  end

  alias_method :inspect, :to_s
end