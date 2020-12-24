# frozen_string_literal: true

class Floor
  attr_accessor :tiles

  # Grid system:
  # x: w-e
  # y: sw - ne
  MOVES = {
    'e' => { x: 1, y: 0 },
    'se' => { x: 1, y: -1 },
    'sw' => { x: 0, y: -1 },
    'w' => { x: -1, y: 0 },
    'nw' => { x: -1, y: 1 },
    'ne' => { x: 0, y: 1 }
  }.freeze

  def initialize
    @tiles = {}
  end

  def process(line)
    directions = directions(line)
    position = tile_position(directions)
    tile = tiles[position]
    tile ||= { state: :white, position: position }

    @tiles[position] = flip_tile(tile)
  end

  def directions(line)
    directions = []
    loop do
      break if line.nil?

      token_match = line.match(/^(e|se|sw|w|nw|ne)/)
      break if token_match.nil?

      directions << token_match[1]
      line.sub!(token_match[1], '')
    end
    directions
  end

  def tile_position(directions, reference = nil)
    position = reference&.clone || { x: 0, y: 0 }

    directions.each do |move|
      position[:x] += MOVES[move][:x]
      position[:y] += MOVES[move][:y]
    end

    position
  end

  def flip_tile(tile)
    tile[:state] = tile[:state] == :white ? :black : :white
    tile
  end

  def black_tiles(group = nil)
    group ||= @tiles.values
    group.select { |tile| tile[:state] == :black }
  end

  def white_tiles(group = nil)
    group ||= @tiles.values
    group.select { |tile| tile[:state] == :white }
  end

  def daily_flip
    new_tiles = {}
    expand_scope

    @tiles.each_value do |tile|
      black_tiles_count = black_tiles(neighbor_tiles(tile)).length
      state = if tile[:state] == :black
                black_tiles_count == 0 || black_tiles_count > 2 ? :white : :black
              else
                black_tiles_count == 2 ? :black : :white
              end
      new_tiles[tile[:position]] = { state: state, position: tile[:position] }
    end

    @tiles = new_tiles
  end

  def expand_scope
    black_tiles.each do |black_tile|
      neighbor_tiles(black_tile).each do |tile|
        @tiles[tile[:position]] ||= tile
      end
    end
  end

  def neighbor_tiles(tile)
    MOVES.keys.map do |direction|
      position = tile_position([direction], tile[:position])
      @tiles[position] || { state: :white, position: position }
    end
  end
end
