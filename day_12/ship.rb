# frozen_string_literal: true

class Ship
  attr_accessor :east, :north, :orientation, :w_east, :w_north
  attr_reader :degree_reference, :orientation_reference

  def initialize
    @east = 0
    @north = 0
    @orientation = 'E'
    @w_east = 10
    @w_north = 1

    @degree_reference = { 0 => 'E', 90 => 'N', 180 => 'W', 270 => 'S' }
    @orientation_reference = degree_reference.invert
  end

  def process(instruction)
    command = instruction[0]
    value = instruction[1..-1].to_i

    if %w[N E S W].include?(command)
      move_waypoint(command, value)
    elsif command == 'F'
      move(value)
    elsif %w[R L].include?(command)
      rotate(command, value)
    else
      raise "Unknow command #{instruction}"
    end
  end

  def move_waypoint(direction, value)
    case direction
    when 'N'
      @w_north += value
    when 'S'
      @w_north -= value
    when 'E'
      @w_east += value
    when 'W'
      @w_east -= value
    end
  end

  def move(value)
    @east += @w_east * value
    @north += @w_north * value
  end

  def rotate(direction, value)
    rotation_angle = (direction == 'L' ? value : -1 * value)
    target_value = orientation_reference[orientation] + rotation_angle
    target_orientation = degree_reference[target_value % 360]
    return if target_orientation == orientation

    @orientation = target_orientation 
    
    rotation_radian = rotation_angle * Math::PI / 180 
    current_east = w_east
    current_north = w_north
    @w_east = (current_east * Math.cos(rotation_radian) - current_north * Math.sin(rotation_radian)).round
    @w_north = (current_east * Math.sin(rotation_radian) + current_north * Math.cos(rotation_radian)).round
  end

  def manhattan_distance
    east.abs + north.abs
  end
end
