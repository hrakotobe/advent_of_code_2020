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

    # set borders
    borders = [data[0], right_border.join(''), data[-1], left_border.join('')]
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

  def reorder_borders!(tile)
    tile[:borders] = [
      tile[:data][0],
      tile[:data].map { |line| line[-1] },
      tile[:data][-1],
      tile[:data].map { |line| line[0] }
    ]
    tile[:borders] << tile[:borders].map(&:reverse)
  end

  def compose_image
    corners = tiles.select { |_id, t| t[:neighbors].count == 2 }
    visited_tiles = {}

    byebug
    current = corners.values.first
    image = current[:data]

    ###

    byebug
    right_tile = current[:neighbors].find { |id| @tiles[id][:borders].include?(current[:borders][1]) }
    down_tile = current[:neighbors].find { |id| @tiles[id][:borders].include?(current[:borders][2]) }

    byebug

    matching_border_index = right_tile[:borders].find_index(right_tile[:borders][1])
    if [4, 6].include?(matching_border_index)
      # horizontal flip
      right_tile[:data] = right_tile[:data].map { |line| line.reverse }
    elsif [5, 7].include?(matching_border_index)
      # vertical flip
      right_tile[:data] = right_tile[:data].reverse
    end
    byebug

    reorder_borders!(right_tile)
    byebug

    most_left_border = right_tile[:borders][3]
    # rotate
    loop do
      byebug

      break if current[:borders][1] == most_left_border

      byebug

      length = right_tile[:data].length
      rotated_data = [[]] * length
      0.upto(length) do |row|
        0.upto(length) do |column|
          rotated_data[column][length - row] = right_tile[:data][row][column]
        end
      end
      most_left_border = right_tile[:data].map { |line| line[0] }
      byebug

    end
  end
end
