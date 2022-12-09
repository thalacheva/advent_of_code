require 'set'

test1 = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb' # 7
test2 = 'bvwbjplbgvbhsrlpgdmjqwftvncz' # 5
test3 = 'nppdvjthqldpwncqszvftbrmjlhg' #  6
test4 = 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' # 10
test5 = 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' # 11

file = File.readlines('day6.txt')

def part1(buffer)
  i = 0
  while i < buffer.length do
    seq = Set.new
    for j in i..i+3 do
      seq << buffer[j]
    end
    break if seq.size == 4
    i += 1
  end

  i + 4
end

def part2(buffer)
  i = 0
  while i < buffer.length do
    seq = Set.new
    for j in i..i+13 do
      seq << buffer[j]
    end
    break if seq.size == 14
    i += 1
  end

  i + 14
end

p part2(test1)
p part2(test2)
p part2(test3)
p part2(test4)
p part2(test5)
p part1(file.first)
p part2(file.first)
