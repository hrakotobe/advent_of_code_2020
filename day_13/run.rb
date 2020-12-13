# frozen_string_literal: true

require 'byebug'

input = File.open('input.txt')
(start, buses) = input.readlines.map(&:strip)

start = start.to_i
buses = buses.split(',').filter { |time| time != 'x' }.map(&:to_i).sort
shortest_wait = buses[-1]
earliest_bus = 0

buses.each do |bus|
  wait_time = bus * (start / bus + 1) - start
  if wait_time < shortest_wait
    earliest_bus = bus
    shortest_wait = wait_time
  end
end

puts shortest_wait * earliest_bus
