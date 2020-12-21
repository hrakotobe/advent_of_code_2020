# frozen_string_literal: true

require 'byebug'
require './mapper'

input = File.open('input.txt')

mapper = Mapper.new

mapper.parse(input)
mapper.compact_allergens
mapper.reduce_to_uniques

non_allergens = mapper.all_ingredients.flatten - mapper.allergens.values.flatten

puts non_allergens.count
puts mapper.dangerous_list
