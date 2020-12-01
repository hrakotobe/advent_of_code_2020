# frozen_string_literal: true

def part1(input)
  pair = find_pair(input, 2020)
  return puts 'No pair found for targeted sum' if pair.nil?

  pair[0] * pair[1]
end

def part2(input)
  trio = find_trio(input.readlines.map(&:to_i), 2020)
  return puts 'No trio found for targeted sum' if trio.empty?

  trio.first.reduce(&:*)
end

def find_pair(input, target)
  trail = {}

  input.each do |line|
    value = line.to_i
    next if value > target

    return [value, trail[value]] unless trail[value].nil?

    trail[target - value] = value
  end
  nil
end

def find_trio(input, target)
  input.combination(3).select { |trio| trio.reduce(&:+) == target }
end

input = File.open('input_1.txt')

# puts part1(input)
puts part2(input)
