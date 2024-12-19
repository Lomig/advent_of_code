# frozen_string_literal: true

class Onsen
  def initialize(designs:, towels:)
    @designs, @towels = designs, towels

    @design_availabilities = {"" => 1}
  end

  def available_designs = @designs.select(&method(:available?))

  def all_designs_count = @designs.sum(&method(:count_patterns))

  private

  def available?(pattern)
    pattern.match?(/^#{Regexp.union(*@towels)}+$/)
  end

  def count_patterns(pattern)
    @design_availabilities[pattern] ||=

      @towels.sum do |towel|
        next 0 if towel.length > pattern.lengthÒ
        next 0 unless pattern.start_with?(towel)

        count_patterns(pattern.delete_prefix(towel))
      end
  end
end
