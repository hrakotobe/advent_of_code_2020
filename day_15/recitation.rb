# frozen_string_literal: true

class Recitation
  attr_accessor :last_number, :encounters, :turn

  def initialize(start_sequence)
    @turn = 0
    @sequence = []
    @encounters = {}
    start_sequence.each do |number|
      @turn += 1
      @last_number = number
      @encounters[number] ||= []
      @encounters[number] << turn
    end
  end

  def step
    @turn += 1

    next_number = if encounters[last_number].nil? || encounters[last_number].length == 1
                    0
                  else
                    encounters[last_number][-1] - encounters[last_number][-2]
                  end

    @last_number = next_number
    encounters[next_number] = encounters[next_number].nil? ? [turn] : [encounters[next_number][-1], turn]
    turn
  end
end
