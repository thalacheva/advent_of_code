require 'pry'

input = File.readlines('day7.txt').map(&:chomp)

def number?(str)
  str.to_i.to_s == str
end

$wires = Hash.new
input.each do |line|
  expression, wire = line.split('->').map(&:strip)
  $wires[wire] = [expression, number?(expression) ? expression.to_i : nil]
end

def calc(wire)
  return wire.to_i if number?(wire)

  value = nil

  if $wires[wire][1]
    value = $wires[wire][1]
  else
    expression = $wires[wire][0]
    value =
      if expression.start_with?('NOT')
        65535 - calc(expression[4..-1])
      elsif expression.include?('AND')
        left, right = expression.split('AND').map(&:strip)
        calc(left) & calc(right)
      elsif expression.include?('OR')
        left, right = expression.split('OR').map(&:strip)
        calc(left) | calc(right)
      elsif expression.include?('LSHIFT')
        left, right = expression.split('LSHIFT').map(&:strip)
        calc(left) << calc(right)
      elsif expression.include?('RSHIFT')
        left, right = expression.split('RSHIFT').map(&:strip)
        calc(left) >> calc(right)
      else
        calc(expression)
      end
  end

  $wires[wire][1] = value
  return value
end

calc('a')
signal = $wires['a'][1]

input.each do |line|
  expression, wire = line.split('->').map(&:strip)
  $wires[wire] = [expression, number?(expression) ? expression.to_i : nil]
end

$wires['b'][1] = signal
calc('a')
p $wires['a']
