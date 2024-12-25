# frozen_string_literal: true

require_relative "../aoc"

class Day25 < AoC
  # custom_input <<~INPUT
  #
  #   #####
  #   .####
  #   .####
  #   .####
  #   .#.#.
  #   .#...
  #   .....
  #
  #   #####
  #   ##.##
  #   .#.##
  #   ...##
  #   ...#.
  #   ...#.
  #   .....
  #
  #   .....
  #   #....
  #   #....
  #   #...#
  #   #.#.#
  #   #.###
  #   #####
  #
  #   .....
  #   .....
  #   #.#..
  #   ###..
  #   ###.#
  #   ###.#
  #   #####
  #
  #   .....
  #   .....
  #   .....
  #   #....
  #   #.#..
  #   #.#.#
  #   #####
  # INPUT
  def result1
    keys, locks = keys_and_locks
    locks.sum { |lock| keys.count { |key| lock.zip(key).map(&:sum).all? { _1 <= 5 } } }
  end

  def result2

  end

  private

  def keys_and_locks
    input.unshift("").each_slice(8).with_object([[], []]) do |cluster, (keys, locks)|
      schematic = cluster[1..].map(&:chars).transpose
      encoding = schematic.map { _1.count { |c| c == "#" } - 1 }
      next locks << encoding if schematic[0][0] == "#"

      keys << encoding
    end
  end
end
