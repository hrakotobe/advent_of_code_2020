# frozen_string_literal: true

require 'byebug'

def bag_containers(input)
  containers = {}
  input.each do |line|
    matches = line.match(/^(?<outermost_bag>.*) bags contain (?<contained>.*)/)
    next if matches.nil?

    containers[matches[:outermost_bag]] ||= []
    containers[matches[:outermost_bag]] = (containers[matches[:outermost_bag]] << contained_bags(matches[:contained])).flatten
  end
  containers
end

def bag_rules(input)
  containers = {}
  input.each do |line|
    matches = line.match(/^(?<outermost_bag>.*) bags contain (?<contained>.*)/)
    next if matches.nil?

    containers[matches[:outermost_bag]] = matches[:contained].scan(/(\d+) ([\w ]+) bags?/)
  end
  containers
end

def contained_bags(description)
  description.scan(/\d+ ([\w ]+) bags?/)
end

def possible_containers(containers, final_bag)
  check_for = [final_bag]
  checked = []

  while check_for.count.positive?
    target = check_for.shift
    containers.each do |key, value|
      check_for |= [key] if value.include?(target)
    end
    checked << target
    check_for -= checked
  end
  checked - [final_bag]
end

def bag_sum(rules, starting_bag)
  return 0 if rules.empty?

  sub_tree = rules[starting_bag]
  return 1 if sub_tree.empty?

  sub_tree.map do |rule|
    puts "#{starting_bag} spwan #{rule[1]} #{rule[0].to_i} x times"
    bag_sum(rules, rule[1]) * rule[0].to_i
  end.reduce(&:+) + 1 # count self
end

input = File.open('input.txt').readlines

# part 1
containers = bag_containers(input)
# puts possible_containers(containers, 'shiny gold').count

# part 2
rules = bag_rules(input)
puts bag_sum(rules, 'shiny gold') - 1 # remove shiny gold bag
