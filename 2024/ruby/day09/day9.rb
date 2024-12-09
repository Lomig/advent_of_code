require_relative "../aoc"

class Day9 < AoC
  input_as :raw

  #   custom_input <<-INPUT
  # 12345
  #   INPUT

  custom_input <<-INPUT
2333133121414131402
  INPUT

  def result1
    disk = input_to_file_system
    data_size = disk.reject { |data| data == "." }.size

    bad_defragment(disk:, data_size:)
      .each_with_index.sum { |(data, index)| index * data }
  end

  def result2
    disk = input_to_file_system

    good_defragment(disk:)
      .each_with_index.sum { |(data, index)| index * data.to_i }
  end

  private

  def bad_defragment(disk:, data_size:)
    index = 0
    while index < disk.size - 1
      next index += 1 if disk[index] != "."

      data = nil
      until data && data != "."
        data = disk.pop
      end

      disk[index] = data
      index += 1
    end

    disk.first(data_size)
  end

  def good_defragment(disk:)
    data_stream = data_stream(disk:)

    chunks(disk:).each_with_object([[], Set.new]) do |chunk, (defragmented_disk, moved_chunk_ids)|
      chunk = chunk.map { "." } if moved_chunk_ids.include?(chunk.first)
      is_data = chunk.first != "."

      if is_data
        data_stream.delete(chunk.first)
        defragmented_disk << chunk
        next
      end

      while chunk.size.positive?
        data_id, data_size = data_stream.find { |_, size| size <= chunk.size }
        break defragmented_disk << chunk unless data_id

        data_stream.delete(data_id)
        chunk = chunk.drop(data_size)
        moved_chunk_ids << data_id
        defragmented_disk << [data_id] * data_size
      end
    end.first.flatten
  end

  def data_stream(disk:)
    disk
      .reject { |data| data == "." }
      .reverse
      .group_by(&:itself)
      .transform_values(&:count)
  end

  def chunks(disk:)
    disk
      .chunk { |data| data == "." }
      .flat_map { |is_free, chunk| chunk.group_by(&:itself).values }
  end

  def input_to_file_system
    input.chars.each_slice(2).with_index.reduce([]) do |acc, ((file_size, free_size), index)|
      acc << [index] * file_size.to_i << ["."] * free_size.to_i
    end.flatten
  end
end
