# frozen_string_literal: true

class Decoder
  attr_reader :current_mask, :mem

  def initialize
    @mem = {}
  end

  def process(line)
    return if mask(line)

    update_mem(line)
  end

  def mask(line)
    matches = line.match(/^mask = (?<mask>[01X]{36})/)
    return false if matches.nil?

    @current_mask = matches[:mask]
    true
  end

  def update_mem(line)
    matches = line.match(/^mem\[(?<index>\d+)\] = (?<value>\d+)/)
    return false if matches.nil?

    index = matches[:index].to_i
    pattern = index.to_s(2).rjust(current_mask.length, '0').chars.each_with_index.map do |char, mask_index|
      %w[1 X].include?(current_mask[mask_index]) ? current_mask[mask_index] : char
    end.join

    update_mem_variation(pattern, matches[:value].to_i)
    puts "Updated for #{pattern}"
  end

  def update_mem_variation(pattern, value)
    if pattern.match?('X')
      update_mem_variation(pattern.sub('X', '0'), value)
      update_mem_variation(pattern.sub('X', '1'), value)
      return
    end

    puts "Set #{pattern} = #{value}"
    @mem[pattern.to_i(2)] = value
  end

  def values_sum
    mem.values.sum
  end
end
