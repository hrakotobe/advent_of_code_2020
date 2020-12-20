# frozen_string_literal: true

class Mapper
  attr_accessor :tiles, :borders

  def initialize
    @tiles = {}
    @borders = {}
  end

  def read_tile(input)
    id = nil
    data = []

    left_border = []
    right_border = []
    input.each do |line|
      if id.nil?
        id = line.match(/Tile (?<id>\d+):/)[:id]
        next
      end

      data << line
      left_border << line[0]
      right_border << line[-1]
    end

    return false if id.nil?

    borders = [data[0], left_border.join(''), data[-1], right_border.join('')]
    borders << borders.map(&:reverse)

    @tiles[id] = { id: id, data: data, borders: borders.flatten }
    @tiles[id][:borders].each do |value|
      @borders[value] ||= []
      @borders[value] << id
    end
    true
  end

  def bind_tiles
    @tiles.each do |id, tile|
      tile[:neighbors] = []
      tile[:borders].each do |border|
        tile[:neighbors] << (@borders[border] - [id])
      end
      tile[:neighbors] = tile[:neighbors].flatten.uniq
    end
  end
end
