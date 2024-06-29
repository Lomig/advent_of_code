# frozen_string_literal: true

require_relative "mapper"

class Almanach
  private attr_reader :seeds, :mappers, :location_mapper

  def initialize(seeds:, raw_mappers:)
    @seeds = seeds
    @mappers = raw_mappers.to_h { |source, mapper_data| [source, Mapper.new(source, *mapper_data)] }
  end

  def seeds_smaller_location_id(candidates: seeds)
    candidates
      .map { |seed_id| traverse_mappers(value: seed_id) }
      .min
  end

  def seed_range_smaller_location_id
    mappers.values.reverse_each.inject([]) do |candidates, mapper|
      mapper
        .map_back(values: candidates)
        .then { |mapped_back_candidates| mapper.add_candidates(mapped_back_candidates) }
    end => candidates

    select_candidate(candidates)
  end

  private

  def traverse_mappers(value:, source: :seed)
    mapper = mappers[source]
    return value unless mapper

    traverse_mappers(value: mapper.map(value:), source: mapper.destination)
  end

  def select_candidate(candidates)
    remove_invalid_candidates(candidates)
      .then { |elected_candidates| seeds_smaller_location_id(candidates: elected_candidates) }
  end

  def seed_ranges
    @seed_ranges ||= seeds.each_slice(2).map { |id, range_length| (id...(id + range_length)) }
  end

  def remove_invalid_candidates(candidates)
    candidates.select do |candidate|
      seed_ranges.any? { |seed_range| seed_range.include?(candidate) }
    end
  end
end
