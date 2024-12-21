# frozen_string_literal: true

class Key
  DIRECTIONS = %w[^ > v <].freeze

  attr_reader :key
  attr_accessor :neighbours

  def initialize(key, neighbours)
    @key = key

    @shortest_paths = Hash.new { |h, k| h[k] = Set.new }
    @shortest_paths[key] << ["A"]

    @distances = Hash.new(Float::INFINITY)
    @distances[key] = 0

    @directions = neighbour_directions(neighbours)
  end

  def direction_to(destination) = @directions[destination.key]

  def distance_from(other_key) = @distances[other_key.key]

  def set_distance_to(destination:, distance:)
    @distances[destination.key] = distance
  end

  def paths_from(other_key) = @shortest_paths[other_key.key]

  def add_path_to(destination:, paths:)
    @shortest_paths[destination.key] += paths
  end

  private

  def neighbour_directions(neighbours)
    neighbours
      .zip(DIRECTIONS)
      .to_h
      .except(nil)
  end
end