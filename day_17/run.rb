# frozen_string_literal: true

require 'byebug'
require './simulator'

initial_input = File.open('input_.txt').readlines.map(&:strip)
simulator = Simulator.new(initial_input)

puts simulator.print
0.upto(5).each do |iteration|
  puts "---- #{iteration} -----\n"
  simulator.step
  puts simulator.print
  puts simulator.active_count
end
