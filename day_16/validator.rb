# frozen_string_literal: true

class Validator
  attr_accessor :rules, :total_count, :rule_positions, :field_order

  def initialize
    @rules = {}
    @total_count = 0
    @rule_positions = {}
  end

  def add_rule(rule)
    return if rule.empty?

    name = rule.scan(/^([\w ]+):/).flatten.first
    ranges = rule.scan(/(\d+-\d+)+[or]*/).flatten.map { |range| range.split('-').map(&:to_i) }

    @rules[name] = ranges
  end

  def valid?(ticket)
    validate_with_field_order(ticket)
  end

  def validate_with_field_order(ticket)
    local_positions = {}
    ticket.each_with_index do |field, index|
      is_valid = false
      rules.each do |name, ranges|
        next if ranges.none? { |range| field.between?(*range) }

        is_valid = true
        local_positions[name] ||= []
        local_positions[name] << index
      end
      return false unless is_valid
    end

    local_positions.each do |name, positions|
      @rule_positions[name] ||= []
      @rule_positions[name] << positions
    end
    true
  end

  def process_field_order
    common_positions = {}
    @rule_positions.each do |name, positions|
      common_positions[name] = positions.reduce(positions[0]) { |common, set| common & set }
    end

    common_positions = common_positions.sort { |a, b| a[1].length <=> b[1].length }
    filtered_positions = {}
    common_positions.length.downto(1) do
      item = common_positions.shift
      filtered_positions[item[0]] = item[1]
      common_positions.each { |pair| pair[1] -= item[1] }
    end

    @field_order = filtered_positions
  end

  def map_ticket(ticket)
    mapped_ticket = {}
    field_order.each { |key, position| mapped_ticket[key] = ticket[position[0]] }

    mapped_ticket
  end
end
