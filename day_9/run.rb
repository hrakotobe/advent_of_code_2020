# frozen_string_literal: true

require 'byebug'

def parse_number_list(input)
  list = []
  input.each { |line| list << line.strip.to_i }
  list
end

def first_out_of_rank(list, window_size)
  window = []

  list.each do |number|
    if window.length < window_size
      window << number
      next
    end

    matching_pair = window.combination(2).select { |pair| pair.reduce(&:+) == number }
    return number if matching_pair.empty?

    window << number
    window.shift
  end

  nil
end

def find_continuous_sum(list, target)
  current_list = list.clone
  loop do
    result = continuous_sum(current_list, target)
    current_list.shift

    return result unless result.empty?
    return nil if current_list.empty?
  end
end

def continuous_sum(list, target)
  window = []
  sum = 0

  list.each do |number|
    sum += number
    window << number

    return window if sum == target
    break if sum > target
  end
  []
end

input = File.open('input.txt')
number_list = parse_number_list(input)

out_of_rank = first_out_of_rank(number_list, 25)
continuous_sum = find_continuous_sum(number_list, out_of_rank)

if continuous_sum.nil?
  puts 'no sum found'
else
  puts "Sum: #{continuous_sum.min + continuous_sum.max}"
end
