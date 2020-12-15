# frozen_string_literal: true

require 'byebug'
require './recitation'

start_sequence = File.open('input.txt').read.strip.split(',').map(&:to_i)
recitation = Recitation.new(start_sequence)

0.upto(30_000_000 - start_sequence.length - 1) do
  puts "#{recitation.step} - #{recitation.last_number}"
end
puts recitation.last_number
