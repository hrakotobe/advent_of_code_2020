# frozen_string_literal: true

require 'byebug'
require './ship'

input = File.open('input.txt')
ship = Ship.new

input.each do |line| 
  ship.process(line.strip)
  puts "Did: #{line.strip} => waypoint: E: #{ship.w_east} N: #{ship.w_north} O: #{ship.orientation} (ship: E:#{ship.east} N:#{ship.north})"
end

puts ship.manhattan_distance
