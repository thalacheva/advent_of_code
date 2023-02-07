require 'pry'
input = File.readlines('day5.txt').map(&:chomp)

tests = [
  'ugknbfddgicrmopn',
  'aaa',
  'jchzalrnumimnmhp',
  'haegwjzuvuyypxyu',
  'dvszwmarrgswjxmb'
]

def nice?(s)
  %w(ab cd pq xy).each do |x|
    return false if s.include?(x)
  end

  vowels = s.scan(/[aeiou]/).count
  double_letter = false
  s.chars.each_with_index do |c, i|
    double_letter = true if c == s.chars[i + 1]
  end

  return double_letter && vowels >= 3
end

# tests.each do |s|
#   p "#{s} is #{nice?(s) ? 'nice' : 'naughty'}"
# end

nice_count = 0

# input.each do |s|
#   nice_count += 1 if nice?(s)
# end

# p nice_count

def nice2?(s)
  pair = false
  s.chars.each_with_index do |c, i|
    x = s[i, 2]
    if i < s.length - 2 && s[i + 2..- 1].include?(x)
      pair = true
      break
    end
  end

  repeats = false
  s.chars.each_with_index do |c, i|
    if c == s[i + 2]
      repeats = true
      break
    end
  end

  pair && repeats
end

# %w(qjhvhtzxzqqjkmpb xxyxx uurcxstgmygtbstg ieodomkazucvgmuy).each do |s|
#   p "#{s} is #{nice2?(s) ? 'nice' : 'naughty'}"
# end

nice_count = 0

input.each do |s|
  nice_count += 1 if nice2?(s)
end

p nice_count
