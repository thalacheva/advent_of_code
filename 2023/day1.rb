lines = File.readlines('day1.txt').map(&:chomp)

def parse1(line)
  numbers = line.scan(/\d/)

  "#{numbers.first}#{numbers.last}".to_i
end

mapping = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}

def parse2(line, mapping)
  f = line.scan(/#{mapping.keys.join('|')}|\d/)
  first = mapping[f.first] || f.first.to_i
  l = line.reverse.scan(/#{mapping.keys.map(&:reverse).join('|')}|\d/)
  last = mapping[l.first.reverse] || l.first.to_i

  "#{first}#{last}".to_i
end

p lines.sum { |line| parse2(line, mapping) }
