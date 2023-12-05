# frozen_string_literal: true

module Mappers; end

class Mappers::Range
  attr_reader :source_boundaries
  private attr_reader :source_range, :destination_range, :destination_offset

  def initialize(destination_id, source_id, range_length)
    @source_range = (source_id...(source_id + range_length))
    @destination_range = (destination_id...(destination_id + range_length))

    @destination_offset = destination_id - source_id
    @source_boundaries = [source_id, source_id + range_length - 1]
  end

  def map(value:)
    return unless source_range.include?(value)

    value + destination_offset
  end

  def map_back(value:)
    return unless destination_range.include?(value)

    value - destination_offset
  end
end
