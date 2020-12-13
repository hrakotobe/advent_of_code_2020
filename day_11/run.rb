# frozen_string_literal: true

require 'byebug'
require './map'

def find_stable_seat_map(map)
  loop do
    map.apply_rules!
    break unless map.dirty
  end
end

input = File.open('input.txt')
map = Map.new(input)
find_stable_seat_map(map)
puts map.occupied_seat_count
