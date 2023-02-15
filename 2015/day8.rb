input = File.readlines('day8.txt').map(&:chomp)

diff = 0
diff2 = 0

input.each do |line|
  diff += line.length - line.undump.length
  diff2 += line.dump.length - line.length
end

p diff
p diff2
