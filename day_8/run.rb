# frozen_string_literal: true

require 'byebug'
require './instruction'

input = File.open('input.txt').readlines

def run_instructions(input)
  instructions = input.map { |line| Instruction.new(line) }
  return if instructions.empty?

  state = { accumulator: 0, pointer: 0 }

  while state[:pointer] < instructions.length && instructions[state[:pointer]].execution_count < 1
    instructions[state[:pointer]].run(state)
  end
  state
end

state = run_instructions(input)
puts state[:accumulator]