# frozen_string_literal: true

require 'byebug'
require './instruction'

input = File.open('input.txt').readlines

def parse_instruction(input)
  input.map.with_index { |line, index| Instruction.new(line, index + 1) }
end

def run_instructions(instructions)
  state = { accumulator: 0, pointer: 0 }
  instructions.each(&:reset_counter)

  while state[:pointer] < instructions.length
    if instructions[state[:pointer]].execution_count > 0
      state[:death_loop] = true
      state[:code] = instructions[state[:pointer]].operation
      break
    end
    instructions[state[:pointer]].run(state)
  end
  state
end

def fix_instructions(instructions)
  candidates = instructions.select(&:nop_or_jmp?)
  iterations_left = candidates.count

  while iterations_left.positive?
    iterations_left -= 1
    candidate = candidates[iterations_left]
    candidate.invert_nop_or_jmp

    state = run_instructions(instructions)
    return state if state[:death_loop].nil?

    candidate.invert_nop_or_jmp # revert
  end
  nil
end

# state = run_instructions(parse_instruction(input))
state = fix_instructions(parse_instruction(input))
puts state.nil? ? 'Failed to fix' : state[:accumulator]
