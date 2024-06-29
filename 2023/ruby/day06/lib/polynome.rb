# frozen_string_literal: true

class Polynome
  attr_reader :a, :b, :c

  def initialize(a:, b:, c:)
    @a = a
    @b = b
    @c = c
  end

  def discriminant
    @discriminant ||= b**2 - 4 * a * c
  end

  def racines
    @racines if defined?(@racines)

    raise "Pas de solution dans R" if discriminant.negative?

    @racines = if discriminant.zero?
      [-b / (2 * a)]
    else
      [
        (-b - Math.sqrt(discriminant)) / (2 * a),
        (-b + Math.sqrt(discriminant)) / (2 * a)
      ].sort
    end
  end

  def integer_solutions_where_greater_than_zero
    bottom_boundary = racines.first + 1
    top_boundary = racines.last - 1

    top_boundary.ceil - bottom_boundary.floor + 1
  end
end
