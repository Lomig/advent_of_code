# frozen_string_literal: true

require "forwardable"

require_relative "aoc_lib/input_reader"

class AoC
  extend Forwardable

  private attr_reader :reader, :input

  def initialize
    input_filename = "%02d" % self.class.name.delete_prefix("Day").to_i
    @reader = InputReader.new(
      input: self.class.input,
      file_name: File.expand_path("../_inputs/#{input_filename}.txt", __dir__),
      structure: self.class.structure || :array,
      formatter: self.class.formatter || :itself
    )

    @input = @reader.read
  end

  def_delegators :reader, :raw_input

  class << self
    attr_reader :structure, :formatter, :input

    def input_as(structure, formatter: nil)
      @structure = structure
      @formatter = formatter
    end

    def custom_input(input)
      @input = input
    end
  end
end
