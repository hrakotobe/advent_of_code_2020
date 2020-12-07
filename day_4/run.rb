# frozen_string_literal: true

require 'byebug'

# ALL_FIELDS = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid']
MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze
EYE_COLORS = %w[amb blu brn gry grn hzl oth].freeze

def count_complete_passports(input)
  passports = read_passports(input)
  passports.map { |passport| complete?(passport) ? 1 : 0 }.reduce(&:+)
end

def count_valid_passports(input)
  passports = read_passports(input)
  passports.map { |passport| valid?(passport) ? 1 : 0 }.reduce(&:+)
end

def read_passports(input)
  fields = []
  passports = []
  input.each do |line|
    if line.strip.length.zero?
      passports << assign_fields(fields.flatten)
      fields = []
      next
    end

    fields << line.strip.split(' ')
  end
  passports << assign_fields(fields.flatten) if fields.length.positive?
  passports
end

def assign_fields(fields)
  passport = {}
  fields.each do |field|
    pair = field.split(':')
    passport[pair[0]] = pair[1]
  end
  passport
end

def complete?(passport)
  (MANDATORY_FIELDS & passport.keys).length == MANDATORY_FIELDS.length
end

def valid?(passport)
  return false unless complete?(passport)

  validation_rules.all? { |rule| rule.call(passport) }
end

def validation_rules
  [
    proc { |passport| passport['byr'].to_i.between?(1920, 2002) },
    proc { |passport| passport['iyr'].to_i.between?(2010, 2020) },
    proc { |passport| passport['eyr'].to_i.between?(2020, 2030) },
    proc { |passport| valid_height?(passport['hgt']) },
    proc { |passport| passport['hcl'].match?(/^#[0-9a-f]{6}$/) },
    proc { |passport| EYE_COLORS.include?(passport['ecl']) },
    proc { |passport| passport['pid'].match?(/^[0-9]{9}$/) }
  ]
end

def valid_height?(value)
  matches = /(?<height>\d+)(?<unit>in|cm)/.match(value)
  return false if matches.nil?

  (matches[:unit] == 'cm' && matches[:height].to_i.between?(150, 193)) ||
    (matches[:unit] == 'in' && matches[:height].to_i.between?(59, 76))
end

input = File.open('input.txt').readlines
puts count_valid_passports(input)
