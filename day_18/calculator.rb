# frozen_string_literal: true

class Calculator
  attr_accessor :space

  def process(expression)
    # puts "Process #{expression}"

    sub_expression = expression.match(/.*(?<deepest>\([\d +*]+\)).*/)
    unless sub_expression.nil?
      sub_result = process(sub_expression[:deepest].gsub('(', '').gsub(')', ''))
      return process(expression.sub(sub_expression[:deepest], sub_result.to_s))
    end

    if expression.match?('\+')
      parts = expression.match(/(?<left_side>\d+) *(?<operation>[+]) *(?<right_side>\d+)/)
      sub_result = process(parts[:left_side]) + process(parts[:right_side])
    else
      parts = expression.match(/(?<left_side>\d+) *(?<operation>[*]) *(?<right_side>\d+)/)
      return expression.to_i if parts.nil?

      sub_result = process(parts[:left_side]) * process(parts[:right_side])
    end
    process(expression.sub(parts[0], sub_result.to_s))
  end
end
