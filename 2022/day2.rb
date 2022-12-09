input = File.readlines('day2.txt')

score = 0
input.each do |line|
  case line.strip
  when 'A X'
    score += 3 + 1
  when 'A Y'
    score += 6 + 2
  when 'A Z'
    score += 0 + 3
  when 'B X'
    score += 0 + 1
  when 'B Y'
    score += 3 + 2
  when 'B Z'
    score += 6 + 3
  when 'C X'
    score += 6 + 1
  when 'C Y'
    score += 0 + 2
  when 'C Z'
    score += 3 + 3
  end
end

puts score

score = 0
input.each do |line|
  case line.strip
  when 'A X'
    score += 0 + 3
  when 'A Y'
    score += 3 + 1
  when 'A Z'
    score += 6 + 2
  when 'B X'
    score += 0 + 1
  when 'B Y'
    score += 3 + 2
  when 'B Z'
    score += 6 + 3
  when 'C X'
    score += 0 + 2
  when 'C Y'
    score += 3 + 3
  when 'C Z'
    score += 6 + 1
  end
end

puts score
