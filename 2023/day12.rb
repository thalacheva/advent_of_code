# --- Day 12: Hot Springs ---
input = File.readlines('day12.txt').map(&:chomp)

def count(springs, groups)
  regex = groups.map { |group| "(#){#{group}}" }.join("(\\.|\\?)+")
  return springs.chars.each_index.
    filter { |i| springs[i] == '?'}.
    combination(groups.sum - springs.count('#')).
    filter do |combination|
      test = springs.dup
      combination.each { |index| test[index] = '#' }
      test.match(regex)
    end.length
end

def part1(input)
  total = 0
  input.each do |row|
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)
    count = count(springs, groups)
    p "#{springs} - #{count}"
    total += count
  end

  total
end

def part2(input)
  total = 0
  sorted = input.sort_by { |row| row.count('?') }.last(43)

  sorted.each_with_index do |row, index|
    p "row #{index}"
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)
    x = count(springs, groups)
    y = count(springs + '?' + springs, groups + groups)
    count = y**4 / x**3

    p "#{springs} - #{count}"
    total += count
    p "total: #{total}"
  end

  total
end

def parse_output(input)
  total = 0
  output = File.readlines('12output.txt').map(&:chomp)
  output.each do |row|
    next if row.start_with?('row')
    total += row.scan(/\d+/).first.to_i
  end

  p "current total #{total}"
  p "left"
  input.sort_by { |x| x.count('?') }.last(43).each { |x| p x }
end

# p part1(input)
# current total 2584898678700
parse_output input

# p part2(input)

