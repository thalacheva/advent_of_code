require 'pry'

def number?(x)
  x !~ /\D/
end

def compare(left, right)
  return 0 if left == right
  return -1 if left.empty?
  return 1 if right.empty?

  if number?(left) && number?(right)
    return left.to_i <=> right.to_i
  end

  result = 0
  while !!left && !!right && result == 0 do
    if left.start_with?('[') && right.start_with?('[')
      left_closing = find_index(left)
      right_closing = find_index(right)
      x = left[1..left_closing-1]
      y = right[1..right_closing-1]
      left = left[left_closing+2..-1]
      right = right[right_closing+2..-1]
      result = compare(x, y)
    elsif left.start_with?('[')
      left_closing = find_index(left)
      x = left[1..left_closing-1]
      left = left[left_closing+2..-1]
      if number?(right)
        result = compare(x, right)
      else
        right_comma = (right.index(',') || 0) - 1
        y = right[0..right_comma]
        right = right[right_comma+2..-1]
        result = compare(x, y)
      end
    elsif right.start_with?('[')
      right_closing = find_index(right)
      y = right[1..right_closing-1]
      right = right[right_closing+2..-1]
      if number?(left)
        result = compare(left, y)
      else
        left_comma = (left.index(',') || 0) - 1
        x = left[0..left_comma]
        left = left[left_comma+2..-1]
        result = compare(x, y)
      end
    else
      left_comma = (left.index(',') || 0) - 1
      right_comma = (right.index(',') || 0) - 1
      x = left[0..left_comma]
      y = right[0..right_comma]
      left = left[left_comma+2..-1]
      right = right[right_comma+2..-1]
      result = compare(x, y)
    end
  end

  return 1 if result == 0 && left && !left.empty?
  return -1 if result == 0 && right && !right.empty?

  result
end

def find_index(x)
  i = 0
  balance = 0
  balance = 1 if x[0] == '['
  while balance > 0 do
    i += 1
    balance += 1 if x[i] == '['
    balance -= 1 if x[i] == ']'
  end

  return i
end

lines = File.readlines('day13.txt')
Pair = Struct.new(:left, :right)
def part1(lines)
  pairs = []
  i = 0
  while i < lines.length do
    pairs << Pair.new(lines[i].chomp, lines[i+1].chomp)
    i += 3
  end
  right_ordered = []
  sum = 0

  pairs.each_with_index do |pair, index|
    result = compare(pair.left, pair.right)
    p "Result for #{index + 1} pair is #{result}"
    if result == -1
      right_ordered << pair
      sum += index + 1
    end
  end

  pp right_ordered
  p sum
end

def part2(lines)
  p1 = '[[2]]'
  p2 = '[[6]]'
  packets = [p1, p2]
  lines.each { |line| packets << line.chomp unless line.chomp.empty? }

  packets.sort! { |x, y| compare(x, y) }
  index1 = packets.index(p1)
  index2 = packets.index(p2)

  p (index1 + 1) * (index2 + 1)
end

# part1(lines)
part2(lines)
