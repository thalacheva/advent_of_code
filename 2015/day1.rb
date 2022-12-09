input = File.readlines('day1.txt')

floor = 0
instructions = input[0].split('')
instructions.each do |char|
  floor += 1 if char == '('
  floor -= 1 if char == ')'
end

puts floor

floor = 0
position = 0
while floor != -1 do
  floor += 1 if instructions[position] == '('
  floor -= 1 if instructions[position] == ')'
  position += 1
end

puts position
