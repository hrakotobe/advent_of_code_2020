# frozen_string_literal: true

require 'byebug'

def run_slope(map:, right: 3, down: 1)
  x = -1 * right
  trees = 0
  map.each_with_index do |line, index|
    next if (index % down) != 0

    x = (x + right) % line.strip.length
    trees += 1 if line[x] == '#'
  end
  trees
end

input = File.open('input.txt')
map = input.readlines
# part 1
# puts run_slope(map: map)
# part 2
slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
tree_hits = slopes.map { |slope| run_slope(map: map, right: slope[0], down: slope[1]) }.reduce(&:*)
puts tree_hits
