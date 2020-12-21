# frozen_string_literal: true

class Mapper
  attr_accessor :allergens, :all_ingredients

  def initialize
    @allergens = {}
    @all_ingredients = []
  end

  def parse(input)
    input.each do |line|
      parts = line.strip.match(/(?<ingredients>[\w ]+) \(contains (?<allergens>[\w ,]+)\)/)
      next if parts.nil?

      ingredients = parts[:ingredients].split(' ')
      @all_ingredients << ingredients
      parts[:allergens].split(', ').each do |allergen|
        @allergens[allergen] ||= []
        @allergens[allergen] << ingredients
      end
    end
  end

  def compact_allergens
    allergens.each_key do |allergen|
      @allergens[allergen] = allergens[allergen].reduce { |a, b| a & b }
    end
  end

  def reduce_to_uniques
    non_unique_keys = []
    unique_values = []

    allergens.each do |key, value|
      if value.count > 1
        non_unique_keys << key
      else
        unique_values << value
      end
    end
    return if non_unique_keys.empty?

    unique_values = unique_values.flatten

    non_unique_keys.each do |key|
      @allergens[key] = allergens[key] - unique_values
    end

    reduce_to_uniques
  end

  def dangerous_list
    allergens.sort { |a, b| a[0] <=> b[0] }.map { |pair| pair[1] }.join(',')
  end
end
