# frozen_string_literal: true

require 'byebug'

def answer_groups(input, init_value)
  groups = []
  current_group = init_value
  input << '' # guarantee an empty line at the end

  input.each do |line|
    answers = line.strip
    if answers.length.zero?
      groups << current_group if current_group != init_value
      current_group = init_value
      next
    end

    current_group = yield(current_group, answers)
  end

  groups
end

input = File.open('input.txt').readlines
all_answers_groups = answer_groups(input, []) do |group_answer, individual_answer|
  group_answer | individual_answer.chars
end

possible_values = (('a'.ord)..('z'.ord)).map(&:chr) << 'a'
common_answers_groups = answer_groups(input, possible_values) do |group_answer, individual_answer|
  group_answer & individual_answer.chars
end

puts all_answers_groups.map(&:length).reduce(&:+)
puts common_answers_groups.map(&:length).reduce(&:+)
