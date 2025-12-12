input = File.readlines('day1.txt')

def part1(input)
  start = 50
  zeros_count = 0
  input.each do |line|
    number = line.scan(/\d+/).first.to_i
    if line.start_with?('L')
      start -= number
    elsif line.start_with?('R')
      start += number
    end

    start %= 100
    zeros_count += 1 if start.zero?
  end

  zeros_count
end

def part2(input)
  start = 50
  zeros_count = 0
  input.each do |line|
    number = line.scan(/\d+/).first.to_i
    if line.start_with?('L')
      start -= number
    elsif line.start_with?('R')
      start += number
    end

    zeros_count += if start.zero?
                     1
                   elsif start.negative?
                     if start == -number
                       start.abs / 100
                     else
                       start.abs / 100 + 1
                     end
                   else
                     start / 100
                   end

    start %= 100
  end

  zeros_count
end

# puts part1(input)
puts part2(input)
