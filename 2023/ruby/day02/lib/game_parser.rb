# frozen_string_literal: true

module GameParser
  extend self

  def parse(raw_line)
    raw_game_id, raw_throws = raw_line.split(":")

    {id: parse_id(raw_game_id), throws: parse_throws(raw_throws)}
  end

  private

  def parse_id(raw_game_id) = raw_game_id[/\d+/].to_i

  def parse_throws(raw_throws) = raw_throws.split(";").map(&parse_single_throw)

  def parse_single_throw = lambda do |raw_throw|
    [extract(:red, from: raw_throw), extract(:green, from: raw_throw), extract(:blue, from: raw_throw)]
  end

  def extract(color, from:)
    from.match(/\d+ #{color}/)[0].to_i
  rescue
    0
  end
end
