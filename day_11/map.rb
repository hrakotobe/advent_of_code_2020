# frozen_string_literal: true

class Map
  # rubocop: disable Naming/MethodParameterName
  # rubocop: disable Metrics/CyclomaticComplexity

  attr_accessor :layout, :last_x, :last_y, :dirty, :simple_strategy

  def initialize(input, simple_strategy = false)
    rows = []
    input.each { |line| rows << line.strip.chars }
    @last_x = rows[0].length - 1
    @last_y = rows.length - 1

    @layout = rows
    @dirty = false
    @simple_strategy = simple_strategy
  end

  def adjacent_positions(x:, y:)
    positions = []
    positions << layout[y - 1][x - 1] if y >= 1 && x >= 1 # NW
    positions << layout[y - 1][x] if y >= 1 # N
    positions << layout[y - 1][x + 1] if y >= 1 && x < last_x # NE
    positions << layout[y][x + 1] if x < last_x # E
    positions << layout[y + 1][x + 1] if y < last_y && x < last_x # SE
    positions << layout[y + 1][x] if y < last_y # S
    positions << layout[y + 1][x - 1] if y < last_y && x >= 1 # SW
    positions << layout[y][x - 1] if x >= 1 # W

    positions.filter { |tile| tile != '.' }
  end

  def line_of_sight_positions(target_x:, target_y:)
    layout.each_with_index do |row, y|
      row.each_with_index do |item, x|
        item = 'X' if target_x == x && target_y == y
        next if y - x != target_y - target_x && x + y != target_x + target_y && x != target_x && y != target_y

        lines[:ns] << item if x == target_x
        lines[:ew] << item if y == target_y
        lines[:nwse] << item if y - x == target_y - target_x
        lines[:swne] << item if x + y == target_x + target_y
      end
    end

    lines.map do |line|
      matches = line.join.match(/(#|L)?\.*X\.*(#|L)?/)
      next if matches.nil?

      matches[1..2].compact
    end.flatten
  end

  def occupy?(x:, y:)
    return adjacent_positions(x: x, y: y).none? { |tile| tile == '#' } if simple_strategy

    line_of_sight_positions(target_x: x, target_y: y).none? { |tile| tile == '#' }
  end

  def free?(x:, y:)
    return (adjacent_positions(x: x, y: y).select { |tile| tile == '#' }.count >= 4) if simple_strategy

    line_of_sight_positions(target_x: x, target_y: y).select { |tile| tile == '#' }.count >= 5
  end

  def apply_rules!
    iteration = []
    layout.each_with_index do |row, y|
      iteration << row.clone
      row.each_with_index do |item, x|
        iteration[y][x] = '#' if item == 'L' && occupy?(x: x, y: y)
        iteration[y][x] = 'L' if item == '#' && free?(x: x, y: y)
      end
    end

    @dirty = layout != iteration
    @layout = iteration
  end

  def occupied_seat_count
    layout.flatten.select { |item| item == '#' }.count
  end

  def print
    puts layout.map { |row| row.join('') }.join("\n")
  end
  # rubocop: enable Naming/MethodParameterName
  # rubocop: enable Metrics/CyclomaticComplexity
end
