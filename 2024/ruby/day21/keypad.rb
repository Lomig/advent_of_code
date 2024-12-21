# frozen_string_literal: true

require_relative "key"

class Keypad
  KEY_DEFINITIONS = {
    "7" => [nil, "8", "4", nil],
    "8" => [nil, "9", "5", "7"],
    "9" => [nil, nil, "6", "8"],

    "4" => ["7", "5", "1", nil],
    "5" => ["8", "6", "2", "4"],
    "6" => ["9", nil, "3", "5"],

    "1" => ["4", "2", nil, nil],
    "2" => ["5", "3", "^", "1"],
    "3" => ["6", nil, "A", "2"],

    "^" => ["2", "A", "v", nil],
    "A" => ["3", nil, ">", "^"],

    "<" => [nil, "v", nil, nil],
    "v" => ["^", ">", nil, "<"],
    ">" => ["A", nil, nil, "v"]
  }.freeze

  def initialize
    @keys = build_keys

    @starting_position = @keys["A"]
  end

  def count_keystrokes(sequence, depth:, cache:)
    cache[[sequence, depth]] ||=
      key_sequence(sequence).each_cons(2).sum do |(current_position, destination)|
        paths = current_position.paths_from(destination)
        next paths.map(&:length).min if depth.zero?

        paths.map do |path|
          count_keystrokes(path.join, depth: depth - 1, cache:)
        end.min
      end
  end

  private

  def key_sequence(sequence)
    [@starting_position] + sequence.chars.map do |key|
      key = "^" if key == "0"
      @keys[key]
    end
  end

  def build_keys
    keys = KEY_DEFINITIONS.to_h { |key, neighbours| [key, Key.new(key, neighbours)] }

    keys.values.each { |key| add_neighbours(key, keys) }
    keys.values.each { |key| compute_shortest_paths(destination: key) }
    keys
  end

  def add_neighbours(key, keys)
    key.neighbours = KEY_DEFINITIONS[key.key].filter_map { |neighbour| keys[neighbour] }
  end

  def compute_shortest_paths(destination:)
    queue = [destination]

    while (current_key = queue.shift)
      current_key.neighbours.each do |neighbour|
        new_distance = current_key.distance_from(destination) + 1
        next if neighbour.distance_from(destination) < new_distance

        direction = neighbour.direction_to(current_key)
        paths = current_key.paths_from(destination).map { |path| [direction] + path }
        neighbour.set_distance_to(destination:, distance: new_distance)
        neighbour.add_path_to(destination:, paths:)
        queue << neighbour
      end
    end
  end
end
