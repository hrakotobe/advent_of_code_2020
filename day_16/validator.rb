class Validator
  attr_accessor :rules, :total_count, :scanning_error_rate

  def initialize
    @rules = []
    @total_count = 0
    @scanning_error_rate = 0
  end

  def add_rule(rule)
    return if rule.empty?

    @rules << rule.scan(/(\d+-\d+)+[or]*/).flatten.map do |range|
      range.split('-').map(&:to_i)
    end
  end

  def valid?(ticket)
    @total_count += 1
    errors = invalid_fields(ticket)
    return true if errors.empty?

    @scanning_error_rate += errors.sum
    false
  end

  def invalid_fields(ticket)
    ticket.select do |field|
      rules.all? do |ranges|
        ranges.none? { |range| field.between?(*range) }
      end
    end
  end
end
