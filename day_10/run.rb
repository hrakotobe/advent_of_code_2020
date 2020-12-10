# frozen_string_literal: true

require 'byebug'

def consecutive_differences(chain)
  differences = {}

  previous = nil
  chain.each do |rating|
    distance = previous.nil? ? rating : rating - previous
    previous = rating

    differences[distance] ||= 0
    differences[distance] += 1
  end

  differences
end

def find_potential_chain(chain)
  return 1 if chain.length <= 1

  count = 0
  start = chain[0]

  chain[1..-1].each_with_index do |rating, index|
    break if rating - start > 3

    count += find_potential_chain(chain[index + 1..-1])
  end
  count
end

def find_potential_chain_compact(list)
  counts = [0] * list.length

  (list.length - 1).downto(0) do |index|
    following_indexes = indexes_within_range(list, list[index])
    counts[index] = [1, counts.values_at(*following_indexes).sum].max
  end
  wall_indexes = indexes_within_range(list, 0)
  counts.values_at(*wall_indexes).sum
end

def indexes_within_range(list, rating)
  list.each_index.select { |index| rating < list[index] && list[index] <= rating + 3 }
end

def rating_list(input)
  list = []
  input.each { |line| list << line.strip.to_i }
  list.sort!
  list.unshift(0)
  list << list[-1] + 3
end

input = File.open('input.txt')
list = rating_list(input)

# differences = consecutive_differences(list)
# puts differences[1] * differences[3]

puts find_potential_chain_compact(list)
