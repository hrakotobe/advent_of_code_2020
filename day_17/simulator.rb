# frozen_string_literal: true

class Simulator
  # rubocop: disable Naming/MethodParameterName
  attr_accessor :space

  def initialize(input)
    @space = {}
    z = 0
    zz = 0

    input.each_with_index do |row, y|
      row.chars.each_with_index do |is_active, x|
        set(x, y, z, zz, is_active == '#')
      end
    end
  end

  def step
    commands = []
    expand_space
    crawl do |x, y, z, zz, is_active|
      count = active_neighbour_count(x, y, z, zz)
      if !is_active && count == 3
        commands << [x, y, z, zz, true] # activate
      elsif is_active && ![2, 3].include?(count)
        commands << [x, y, z, zz, false] # inactivate
      end
    end

    commands.each { |command| set(*command) }
  end

  def active_neighbour_count(x, y, z, zz)
    count = 0
    [zz - 1, zz, zz + 1].each do |current_zz|
      [z - 1, z, z + 1].each do |current_z|
        [y - 1, y, y + 1].each do |current_y|
          [x - 1, x, x + 1].each do |current_x|
            next if current_x == x && current_y == y && current_z == z && current_zz == zz
            next unless get(current_x, current_y, current_z, current_zz)

            count += 1
          end
        end
      end
    end
    count
  end

  # def print
  #   current_z = nil
  #   current_y = nil
  #   crawl do |x, y, z, is_active|
  #     puts "\n\nZ = #{z}" if z != current_z
  #     current_z = z
  #     printf "\n#{z}, #{y}, #{x} " if y != current_y
  #     current_y = y

  #     printf is_active ? '#' : '.'
  #   end
  #   nil
  # end

  def active_count
    count = 0
    crawl { |_x, _y, _z, _zz, is_active| count += 1 if is_active }
    count
  end

  ################

  def set(x, y, z, zz, active, target = @space)
    target[zz] ||= {}
    target[zz][z] ||= {}
    target[zz][z][y] ||= {}
    target[zz][z][y][x] = active
  end

  def get(x, y, z, zz)
    space.dig(zz, z, y, x) == true
  end

  def crawl
    space.each do |zz, zz_value|
      zz_value.each do |z, z_value|
        z_value.each do |y, y_value|
          y_value.each do |x, is_active|
            yield(x, y, z, zz, is_active)
          end
        end
      end
    end
  end

  def expand_space
    new_space = {}
    crawl do |x, y, z, zz, is_active|
      next unless is_active

      [zz - 1, zz, zz + 1].each do |current_zz|
        [z - 1, z, z + 1].each do |current_z|
          [y - 1, y, y + 1].each do |current_y|
            [x - 1, x, x + 1].each do |current_x|
              activate = get(current_x, current_y, current_z, current_zz)
              set(current_x, current_y, current_z, current_zz, activate, new_space)
            end
          end
        end
      end
    end
    @space = new_space
  end

  # rubocop: enable Naming/MethodParameterName
end
