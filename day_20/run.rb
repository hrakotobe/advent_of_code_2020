# frozen_string_literal: true

require 'byebug'
require './mapper'

input = File.open('input.txt')
mapper = Mapper.new

block = []
input.each do |line|
  if line.strip.empty?
    mapper.read_tile(block)
    block = []
    next
  end

  block << line.strip
end
mapper.read_tile(block) # last block

##
mapper.bind_tiles

corner_tiles = mapper.tiles.select { |_id, t| t[:neighbors].count == 2 }
puts corner_tiles.keys.map(&:to_i).reduce { |a, b| a * b }

mapper.compose_image