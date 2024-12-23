# frozen_string_literal: true

class Computer
  attr_reader :name, :network

  def initialize(name)
    @name = name
    @network = []
  end

  def owned_by_historian? = @name[0] == "t"

  def connected_to?(other_computer) = @network.include?(other_computer)

  def connect(other_computer)
    return if @network.include?(other_computer)

    @network << other_computer
    other_computer.connect(self)
  end
end
