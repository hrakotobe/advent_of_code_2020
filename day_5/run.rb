# frozen_string_literal: true

require 'byebug'

def find_seat(seats)
  cursor = 0
  seats.sort[1..-2].each do |id|
    cursor = id if cursor == 0
    return id - 1 if id - cursor == 2

    cursor = id
  end
end

def seat_id(seat)
  # puts "#{seat} #{row(seat[0..6])} #{col(seat[-3..-1])}"
  row(seat[0..6]) * 8 + col(seat[-3..-1])
end

def row(value)
  value.gsub('B', '1').gsub('F', '0').to_i(2)
end

def col(value)
  value.gsub('R', '1').gsub('L', '0').to_i(2)
end

input = File.open('input.txt').readlines
seats = input.map { |seat| seat_id(seat.strip) }

puts find_seat(seats)
