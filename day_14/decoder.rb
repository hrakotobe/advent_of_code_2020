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
    matches = line.match(/^mask = ([01X]{36})/)
    return false if matches.nil?

    update_mask(matches[0])
    true
  end

  def update_mem(line)
    matches = line.match(/^mem\[(?<index>\d+)\] = (?<value>\d+)/)
    return false if matches.nil?

    masked_value = (matches[:value].to_i | current_mask[:or]) & current_mask[:and]
    puts "Set #{matches[:index]} = #{masked_value} (was #{matches[:value]})"
    @mem[matches[:index].to_i] = masked_value
  end

  def update_mask(mask)
    @current_mask = { or: mask.gsub(/[^1]/, '0').to_i(2), and: mask.gsub(/[^0]/, '1').to_i(2) }
  end

  def values_sum
    mem.values.sum
  end
end
