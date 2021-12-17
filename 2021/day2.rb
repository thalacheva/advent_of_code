n = File.readlines('Projects/advent_of_code/input.txt')
x = 0
y = 0
aim = 0
n.each do |v|
 d, c = v.split
 if d == 'forward'
  x += c.to_i
  y += aim * c.to_i
 elsif d == 'up'
  aim -= c.to_i
 else
  aim += c.to_i
 end
end

puts x*y
