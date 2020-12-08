# frozen_string_literal: true
require 'byebug'

class Instruction
  attr_accessor :execution_count, :operation, :parameter

  def initialize(line)
    @execution_count = 0
    parse(line)
  end

  def parse(line)
    pair = line.split(' ')
    @operation = pair[0]
    @parameter = pair[1].to_i
  end

  def run(state)
    puts "##{state[:pointer]} #{operation}: #{parameter} (#{execution_count})"
    @execution_count += 1
    case operation
    when 'acc'
      state[:accumulator] += parameter
      state[:pointer] += 1
    when 'jmp'
      state[:pointer] += parameter
    when 'nop'
      state[:pointer] += 1
    end
  end
end
