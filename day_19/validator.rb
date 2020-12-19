# frozen_string_literal: true

class Validator
  attr_accessor :rules

  def initialize
    @rules = {}
  end

  def add_rule(definition)
    rule = definition.match(/(?<id>\d+): (?<body>.+)/)
    return false if rule.nil?

    return true if add_character_rule(rule[:id], rule[:body])

    add_redirection_rule(rule[:id], rule[:body])
  end

  def add_character_rule(id, definition)
    character_rule = definition.match(/"(\w+)"/)
    return false if character_rule.nil?

    @rules[id] = { id: id, type: :character, value: character_rule[1] }
    true
  end

  def add_redirection_rule(id, definition)
    rule = definition.match(/(?<left_side>[\d ]+) ?\|? ?(?<right_side>[\d ]*)/)
    return false if rule.nil?

    redirects = [rule[:left_side].split(' ')]
    redirects << rule[:right_side].split(' ') unless rule[:right_side].empty?

    @rules[id] = { id: id, type: :redirect, value: redirects }
    true
  end

  def match_rule(rule, target)
    raise "No target left for rule #{rule[:id]}" if target.empty?

    if rule[:type] == :character
      raise "Rule #{rule[:id]} not matched on #{target}" unless target.match?(/^#{rule[:value]}/)

      return target.sub(rule[:value], '')
    end

    rule[:value].each do |group|
      local_target = target
      begin
        group.each do |id|
          local_target = match_rule(rules[id], local_target)
        end
        return local_target
      rescue StandardError => e
        # puts "Group #{group} not matching"
      end
    end

    raise "No Group matched in rule #{rule}"
  end

  def valid?(line)
    match_rule(rules['0'], line.strip).empty?
  rescue StandardError => e
    # puts e
  end
end
