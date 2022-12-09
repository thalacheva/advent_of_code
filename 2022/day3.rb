input = File.readlines('day3.txt')

def part1(input)
  score = 0

  input.each do |line|
    n = line.chomp.length
    part1 = line.chomp.slice(0, n/2).split('')
    part2 = line.chomp.slice(n/2, n).split('')
    x = (part1 & part2).first

    score += to_score(x)
  end

  puts score
end

def part2(input)
  score = 0
  n = 0

  while n < input.length do
    x = (input[n].chomp.split('') & input[n + 1].chomp.split('') & input[n + 2].chomp.split('')).first
    score += to_score(x)
    n += 3
  end

  p score
end

def to_score(x)
  return  x.ord - 'A'.ord + 27 if x.ord <= 'Z'.ord

  x.ord - 'a'.ord + 1
end

part1(input)
part2(input)
