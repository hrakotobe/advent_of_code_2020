# frozen_string_literal: true

require 'byebug'
require './game'

input = File.open('input.txt')

game = Game.new

# byebug
game.parse_decks(input)
count = 0
loop do
  count += 1
  puts "-- round #{count}"
  puts game.play_recursive_round
  break unless game.winner.nil? || count > 100
end
puts game.score
