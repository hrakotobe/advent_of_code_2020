# frozen_string_literal: true

class Ship
  attr_accessor :east, :north, :orientation
  attr_reader :degree_reference, :orientation_reference

  def initialize
    @east = 0
    @north = 0
    @orientation = 'E'

    @degree_reference = { 0 => 'E', 90 => 'S', 180 => 'W', 270 => 'N' }
    @orientation_reference = degree_reference.invert
  end

  def process(instruction)
    command = instruction[0]
    value = instruction[1..-1].to_i

    if %w[N E S W].include?(command)
      move(command, value)
    elsif command == 'F'
      move(orientation, value)
    elsif %w[R L].include?(command)
      rotate(command, value)
    else
      raise "Unknow command #{instruction}"
    end
  end

  def move(direction, value)
    case direction
    when 'N'
      @north += value
    when 'S'
      @north -= value
    when 'E'
      @east += value
    when 'W'
      @east -= value
    end
  end

  def rotate(direction, value)
    target_value = orientation_reference[orientation] + (direction == 'R' ? value : -1 * value)
    @orientation = degree_reference[target_value % 360]
  end

  def manhattan_distance
    east.abs + north.abs
  end
end
