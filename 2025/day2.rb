input = File.read('day2.txt').split(',')

def twice1?(number)
  str = number.to_s
  if str.length.even?
    mid = str.length / 2
    left = str[0...mid]
    right = str[mid..]
    left == right
  else
    false
  end
end

def twice2?(number)
  str = number.to_s

  (1..(str.length / 2)).each do |i|
    seq = str[0, i]

    next if str.length % seq.length != 0

    times = str.length / seq.length
    next if times < 2

    built = seq * times
    return true if built == str
  end

  false
end

ranges = input.map do |pair|
  a, b = pair.split('-').map(&:to_i)
  (a..b)
end

sum = 0

ranges.each do |range|
  range.each do |i|
    sum += i if twice2?(i)
  end
end

puts sum
