# frozen_string_literal: true

require_relative "../aoc"

class Day5 < AoC
  def result1
    rules, pages = parse_input

    pages
      .select { |manual| valid?(manual:, rules:) }
      .sum(&middle_page)
  end

  def result2
    rules, pages = parse_input

    pages
      .reject { |manual| valid?(manual:, rules:) }
      .sum { |manual| find_middle_page_by_rules_index(manual:, rules:) }
  end

  private

  def valid?(manual:, rules:)
    rules.all? do |(first_page, second_page)|
      manual.index(first_page) < manual.index(second_page)
    rescue
      true
    end
  end

  def middle_page = ->(manual) { manual[manual.count / 2] }

  def find_middle_page_by_rules_index(manual:, rules:)
    manual.find do |page|
      index_according_to_rules(page:, manual:, rules:) == manual.count / 2
    end
  end

  def index_according_to_rules(page:, manual:, rules:)
    manual.count -
      manual.sum { |other_pages| rules_applied_to_two_pages(page:, other_pages:, rules:) } -
      1
  end

  def rules_applied_to_two_pages(page:, other_pages:, rules:)
    rules.count { |(first_page, second_page)| page == first_page && other_pages == second_page }
  end

  def parse_input
    end_of_rules = false

    input.each_with_object([[], []]) do |line, (rules, pages)|
      next (end_of_rules = true) if line == ""

      next (pages << parse_pages(line)) if end_of_rules
      rules << parse_rules(line)
    end
  end

  def parse_pages(line) = line.split(",").map(&:to_i)

  def parse_rules(line) = line.split("|").map(&:to_i)
end
