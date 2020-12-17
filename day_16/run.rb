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
  current_line = raw_line.strip
  next if current_line.empty?

  if current_line == 'your ticket:'
    processor = proc { |line| my_ticket << parse_ticket(line) }
    next
  end

  if current_line == 'nearby tickets:'
    processor = proc { |line| validator.valid?(parse_ticket(line)) }
    next
  end

  processor.call(current_line)
end

validator.process_field_order
mapped_ticket = validator.map_ticket(my_ticket.flatten)
puts mapped_ticket.keys.select { |key| key.match?(/^departure/) }.reduce(1) { |sum, key| sum * mapped_ticket[key] }
