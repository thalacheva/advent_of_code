input = File.readlines('day3.txt').map(&:chomp).map { |line| line.split('').map(&:to_i) }

def part1(input)
  sum = 0
  input.each do |row|
    max = 0
    for i in 0...row.length
      for j in i + 1...row.length
        candidate = (row[i].to_s + row[j].to_s).to_i
        max = candidate if candidate > max
      end
    end

    sum += max
  end

  p sum
end

def max_number(row)
  str = ''
  last_index = -1

  12.downto(1) do |d|
    max = -1
    for i in last_index + 1..row.length - d
      if row[i] > max
        max = row[i]
        last_index = i
      end
    end

    str += max.to_s
  end

  str.to_i
end

def part2(input)
  sum = 0
  input.each do |row|
    sum += max_number(row)
  end

  p sum
end

part2(input)
