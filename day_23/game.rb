# frozen_string_literal: true

class Game
  attr_accessor :current_set

  def initialize(input)
    @current_set = input.chars
  end

  def generate_a_million_cups
    @current_set << (current_set.length..1_000_000)
    @current_set.flattten!
  end

  def current_cup
    current_set[0]
  end

  def move
    pick_up = pick_cups
    destination = destination_cup_index
    destination_label = current_set[destination]

    @current_set = [current_set[0..destination_cup_index], pick_up, current_set[destination_cup_index + 1..-1]].flatten
    @current_set << @current_set.shift # move start to next current_cup, wraparound old one
    # byebug
    puts "cups: #{current_set.join(' ')}\npick up: #{pick_up.join(' ')}\ndestination: #{destination_label}"
  end

  def pick_cups
    pick_up = current_set[1..3]
    @current_set -= pick_up
    pick_up
  end

  def destination_cup_index
    label = current_set.select { |cup| cup < current_cup }.max
    label ||= current_set.max # wrap around if not found

    current_set.find_index(label)
  end

  def final_state
    start = current_set.find_index('1')
    [current_set[start + 1..-1], current_set[0...start]].flatten.join
  end
end
