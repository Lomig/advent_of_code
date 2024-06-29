# frozen_string_literal: true

module AlmanachParser
  extend self

  MAPPER_TYPE_REGEXP = /(?<source>\w+)-to-(?<destination>\w+) map:/

  def parse(raw_almanach)
    {
      seeds: raw_almanach.shift.scan(/\d+/).map(&:to_i),
      raw_mappers: raw_mappers(raw_almanach)
    }
  end

  private

  def raw_mappers(raw_almanach)
    raw_almanach.each_with_object([]) do |line, mappers|
      next mappers << [] if line.empty?

      mapper_type = line.match(MAPPER_TYPE_REGEXP)
      next mappers.last << mapper_type[:source].to_sym << [mapper_type[:destination].to_sym] if mapper_type

      mappers.last.last << line.scan(/\d+/).map(&:to_i)
    end.to_h
  end
end
