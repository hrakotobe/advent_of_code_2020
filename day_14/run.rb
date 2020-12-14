# frozen_string_literal: true

require 'byebug'
require './decoder'

input = File.open('input.txt')

decoder = Decoder.new

input.each { |line| decoder.process(line.strip) }

puts "Sum: #{decoder.values_sum}"
