# frozen_string_literal: true

require 'byebug'
require './validator'

validator = Validator.new

def parse_ticket(line)
  line.split(',').map(&:to_i)
end

my_ticket = []
processor = proc { |line| validator.add_rule(line) }
File.open('input.txt').each do |raw_line|
  line = raw_line.strip
  next if line.empty?

  if line == 'your ticket:'
    processor = proc { |line| my_ticket << parse_ticket(line) }
    next
  end

  if line == 'nearby tickets:'
    processor = proc { |line| validator.valid?(parse_ticket(line)) }
    next
  end

  processor.call(line)
end

puts validator.scanning_error_rate
