# frozen_string_literal: true

require 'byebug'
require './game'

input = '137826495'
# input = '389125467'
game = Game.new(input)

1.upto(100) do |i|
  puts "-- move #{i} --"
  game.move
end

puts game.final_state
