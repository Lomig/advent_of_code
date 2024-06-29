# frozen_string_literal: true

require_relative "mappers/range"

class Mapper
  attr_reader :source, :destination
  private attr_reader :ranges

  def initialize(source, destination, *ranges)
    @source = source
    @destination = destination
    @ranges = ranges.map { |range| Mappers::Range.new(*range) }
  end

  def map(value:)
    ranges.each do |range|
      mapped_value = range.map(value:)
      return mapped_value if mapped_value
    end

    value
  end

  def map_back(values:) = values.map(&map_back_single_value)

  def add_candidates(candidates) = candidates + ranges.flat_map(&:source_boundaries)

  private

  def map_back_single_value = lambda do |value|
    ranges.each do |range|
      mapped_back_value = range.map_back(value:)
      return mapped_back_value if mapped_back_value
    end

    value
  end
end
