require 'pry'

input = File.readlines('day7.txt').map(&:chomp)

def number?(str)
  str.to_i.to_s == str
end

$wires = Hash.new
input.each do |line|
  expression, wire = line.split('->').map(&:strip)
  $wires[wire] = expression
end

def calc(wire)
  if number?(wire)
    p wire
    return wire.to_i
  end

  expression = $wires[wire]
  if expression.start_with?('NOT')
    return 65535 - calc(expression[4..-1])
  elsif expression.include?('AND')
    left, right = expression.split('AND').map(&:strip)
    return calc(left) & calc(right)
  elsif expression.include?('OR')
    left, right = expression.split('OR').map(&:strip)
    return calc(left) | calc(right)
  elsif expression.include?('LSHIFT')
    left, right = expression.split('LSHIFT').map(&:strip)
    return calc(left) << calc(right)
  elsif expression.include?('RSHIFT')
    left, right = expression.split('RSHIFT').map(&:strip)
    return calc(left) >> calc(right)
  else
    return calc(expression)
  end
end

p calc('a')
