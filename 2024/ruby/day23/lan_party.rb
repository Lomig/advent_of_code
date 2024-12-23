# frozen_string_literal: true

class LanParty
  def initialize
    @computers = {}
  end

  def networks_of_three_with_historian
    nanonetworks
      .flat_map { |network| network.combination(3).to_a }
      .uniq
      .select { |network| network.any?(&:owned_by_historian?) }
  end

  def biggest_network
    bron_kerbosch(candidates: @computers.values)
      .max_by { |network| network.size }
  end

  def connect(computer_name1, computer_name2)
    computer1 = @computers[computer_name1] ||= Computer.new(computer_name1)
    computer2 = @computers[computer_name2] ||= Computer.new(computer_name2)

    computer1.connect(computer2)
  end

  private

  def nanonetworks
    bron_kerbosch(
      candidates: @computers.values # All vertices can be added initially
    ).select { |network| network.size >= 3 }
  end

  def bron_kerbosch(candidates:, potential_clique: [], excluded: [], found_cliques: [])
    return found_cliques << potential_clique if candidates.empty? && excluded.empty?

    pivot = candidates.union(excluded).first

    candidates.dup.each do |current_candidate|
      next if current_candidate.connected_to?(pivot)

      bron_kerbosch(
        potential_clique: potential_clique.union([current_candidate]),
        candidates: candidates.intersection(current_candidate.network),
        excluded: excluded.intersection(current_candidate.network),
        found_cliques:
      )

      candidates.delete(current_candidate)
      excluded << current_candidate
    end
    found_cliques
  end
end
