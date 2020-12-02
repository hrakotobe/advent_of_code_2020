# frozen_string_literal: true

require 'byebug'

def check_passwords(input)
  valid_password_count = 0
  input.each do |line|
    fields = line.strip.split(':')
    next if fields.length != 2

    valid_password_count += 1 if valid_toboggan?(rule: parse_rule(fields[0]), password: fields[1].strip)
  end
  valid_password_count
end

def valid_sled?(rule:, password:)
  key_character_count = password.count(rule[:character])

  rule[:min] <= key_character_count && key_character_count <= rule[:max]
end

def valid_toboggan?(rule:, password:)
  (password[rule[:min] - 1] == rule[:character]) ^ (password[rule[:max] - 1] == rule[:character])
end

def parse_rule(rule)
  matches = rule.match(/(?<min>\d+)-(?<max>\d+) (?<character>.)/)
  return if matches.nil?

  {
    character: matches[:character],
    min: matches[:min].to_i,
    max: matches[:max].to_i
  }
end

input = File.open('input.txt')
puts check_passwords(input)
