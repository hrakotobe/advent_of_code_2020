# frozen_string_literal: true

require 'byebug'
require './ship'

input = File.open('input.txt')
ship = Ship.new

input.each { |line| ship.process(line.strip) }

puts ship.manhattan_distance
