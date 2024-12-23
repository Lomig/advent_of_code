# frozen_string_literal: true

require_relative "../aoc"
require_relative "lan_party"
require_relative "computer"

class Day23 < AoC
  input_as :array, formatter: ->(line) { line.split("-") }

  def result1 = lan_party.networks_of_three_with_historian.count

  def result2 = lan_party.biggest_network.map(&:name).sort.join(", ")

  private

  def lan_party
    input.each_with_object(LanParty.new) do |(computer_name1, computer_name2), party|
      party.connect(computer_name1, computer_name2)
    end
  end
end
