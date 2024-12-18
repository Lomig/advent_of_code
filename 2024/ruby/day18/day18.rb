require_relative "../aoc"

require_relative "space"

class Day18 < AoC
  input_as :array, formatter: ->(line) { line.split(",").then { Complex(_1.to_i, -_2.to_i) } }

  KILOBYTE = 1_024

  def result1 = memory_space_after_kilobyte.traverse!.count

  def result2
    memory_space = memory_space_after_kilobyte
    path = memory_space.traverse!

    KILOBYTE.upto(input.count - 1).each do |i|
      byte = input[i]
      memory_space << byte
      next unless path.include?(byte)

      path = memory_space.traverse!
      break input[i] if path.count.zero?
    end => first_blocking_byte

    "#{first_blocking_byte.real},#{-first_blocking_byte.imaginary}"
  end

  private

  def memory_space_after_kilobyte
    input
      .first(KILOBYTE)
      .each_with_object(MemorySpace.new) do |coordinates, memory_space|
      memory_space << coordinates
    end
  end
end
