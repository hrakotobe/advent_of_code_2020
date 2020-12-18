# frozen_string_literal: true

class Simulator
  # rubocop: disable Naming/MethodParameterName
  attr_accessor :space

  def initialize(input)
    @space = {}
    z = 0

    input.each_with_index do |row, y|
      row.chars.each_with_index do |is_active, x|
        set(x, y, z, is_active == '#')
      end
    end
  end

  def step
    commands = []
    expand_space
    crawl do |x, y, z, is_active|
      count = active_neighbour_count(x, y, z)
      if !is_active && count == 3
        commands << [x, y, z, true] # activate
      elsif is_active && ![2, 3].include?(count)
        commands << [x, y, z, false] # inactivate
      end
    end

    commands.each { |command| set(*command) }
  end

  def active_neighbour_count(x, y, z)
    count = 0
    [z - 1, z, z + 1].each do |current_z|
      [y - 1, y, y + 1].each do |current_y|
        [x - 1, x, x + 1].each do |current_x|
          next if current_x == x && current_y == y && current_z == z
          next unless get(current_x, current_y, current_z)

          count += 1
        end
      end
    end
    count
  end

  def print
    current_z = nil
    current_y = nil
    crawl do |x, y, z, is_active|
      puts "\n\nZ = #{z}" if z != current_z
      current_z = z
      printf "\n#{z}, #{y}, #{x} " if y != current_y
      current_y = y

      printf is_active ? '#' : '.'
    end
    nil
  end

  def active_count
    count = 0
    crawl { |_x, _y, _z, is_active| count += 1 if is_active }
    count
  end

  ################

  def set(x, y, z, active, target = @space)
    target[z] ||= {}
    target[z][y] ||= {}
    target[z][y][x] = active
  end

  def get(x, y, z)
    space.dig(z, y, x) == true
  end

  def crawl
    space.each do |z, z_value|
      z_value.each do |y, y_value|
        y_value.each do |x, is_active|
          yield(x, y, z, is_active)
        end
      end
    end
  end

  def expand_space
    new_space = {}
    crawl do |x, y, z, is_active|
      next unless is_active

      [z - 1, z, z + 1].each do |current_z|
        [y - 1, y, y + 1].each do |current_y|
          [x - 1, x, x + 1].each do |current_x|
            activate = get(current_x, current_y, current_z)
            set(current_x, current_y, current_z, activate, new_space)
          end
        end
      end
    end
    @space = new_space
  end

  # rubocop: enable Naming/MethodParameterName
end
