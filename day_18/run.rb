# frozen_string_literal: true

require 'byebug'
require './calculator'

calculator = Calculator.new

sum = File.open('input.txt').readlines.map do |line|
  calculator.process(line.strip)
end.sum

puts sum