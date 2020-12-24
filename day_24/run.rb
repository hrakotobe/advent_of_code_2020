# frozen_string_literal: true

require 'byebug'
require './floor'

input = File.open('input.txt')

floor = Floor.new
input.each do |line|
  floor.process(line.strip)
end

(1..100).each do |day|
  floor.daily_flip
  puts "day #{day}: #{floor.black_tiles.length}"
end
