# --- Day 12: Hot Springs ---
springs = File.readlines('day12.txt').map(&:chomp)

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

def part1(springs)
  total = 0
  springs.each do |row|
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)
    count = count(springs, groups)
    p "#{springs} - #{count}"
    total += count
  end

  total
end

def part2(springs)
  total = 0
  sorted = springs.sort_by { |row| row.count('?') }

  sorted.each_with_index do |row, index|
    p "row #{index}"
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)

    a = springs + '?' + springs
    b = a.split(/\.+/)
    g = groups + groups
    x = 0
    if b.length == groups.length * 2
      b.each_with_index do |group, index|
        x *= count(group, [g[index]])
      end
    else

    end

    y = count(springs, groups)
    count = x**4 / y**3

    p "#{springs} - #{count}"
    total += count
    p "total: #{total}"
  end

  total
end

def parse_output(springs)
  total = 0
  output = File.readlines('12output.txt').map(&:chomp)
  output.each do |row|
    next if row.start_with?('row')
    total += row.scan(/\d+/).first.to_i
  end

  p "total #{total}"
  p "left"
  springs.sort_by { |x| x.count('?') }.last(49).each { |x| p x }
end

# p part1(springs)
# p part2(springs)
parse_output springs
