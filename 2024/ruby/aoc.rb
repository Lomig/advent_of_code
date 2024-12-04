# frozen_string_literal: true

require "forwardable"

require_relative "aoc_lib/input_reader"

class AoC
  extend Forwardable

  private attr_reader :reader, :input

  def initialize
    @reader = InputReader.new(
      input: self.class.input,
      file_name: File.expand_path("../_inputs/#{"%02d" % self.class.day}.txt", __dir__),
      structure: self.class.structure || :array,
      formatter: self.class.formatter || :itself
    )

    @input = @reader.read
  end

  def_delegators :reader, :raw_input

  class << self
    attr_reader :structure, :formatter, :day, :input

    def current_day(day)
      @day = day
    end

    def input_as(structure, formatter: nil)
      @structure = structure
      @formatter = formatter
    end

    def custom_input(input)
      @input = input
    end
  end
end
