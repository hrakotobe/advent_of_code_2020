# frozen_string_literal: true

require 'byebug'
require './validator'

input = File.open('input.txt').readlines.map(&:strip)
validator = Validator.new

count = 0
input.each do |line|
  next if line.empty? || validator.add_rule(line)

  # values
  if validator.valid?(line)
    count += 1
    puts "#{line} O"
  else
    puts "#{line} X"
  end
end
puts count
