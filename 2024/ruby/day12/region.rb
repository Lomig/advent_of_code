# frozen_string_literal: true

class Region
  attr_reader :kind
  private attr_reader :crops

  def initialize(crop)
    @kind = crop.kind
    @crops = populate_region(crop)
  end

  def area = crops.count

  def perimeter = crops.sum(&:perimeter)

  def sides = crops.sum(&:corners)

  def price = area * perimeter

  def discounted_price = area * sides

  def to_s
    "<Region #{kind}: area #{area}, perimeter #{perimeter}, price #{price}, sides #{sides}>"
  end
  alias_method :inspect, :to_s

  private

  def populate_region(crop)
    crops = Set.new
    queue = [crop]

    while (current_crop = queue.pop)
      crops << current_crop
      current_crop.region = self

      current_crop.regional_neighbours.each do |neighbour|
        next if crops.include?(neighbour)

        queue << neighbour
      end
    end

    crops
  end
end