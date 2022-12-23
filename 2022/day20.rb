require 'pry'

file = File.readlines('day20.txt')
Number = Struct.new(:value, :moved)
numbers = []
file.each do |line|
  numbers << Number.new(line.chomp.to_i, false)
end
n = numbers.length
while numbers.reject(&:moved).length > 0 do
  current = numbers.reject(&:moved).first
  i = numbers.index(current)
  current.moved = true
  next if current.value % n == 0 || current.value == 0

  v = current.value.abs % n
  v = -v if current.value < 0
  m = i + v

  if v < 0
    m = n + m - 1 if m < 0
    m = n - 1 if m == 0
  else
    m = m - n + 1 if m > n - 1
    m = 0 if m == n - 1
  end

  numbers.insert(m, numbers.delete_at(i))
  # p "#{current.value} moves at index #{m}"
  # p numbers.map(&:value)
end

zero = numbers.find_index { |n| n.value == 0 }
i1 = (zero + 1000) % n
i2 = (zero + 2000) % n
i3 = (zero + 3000) % n

p "i1=#{i1}, i2=#{i2}, i3=#{i3}"
p "i1=#{numbers[i1].value}, i2=#{numbers[i2].value}, i3=#{numbers[i3].value}"
p numbers[i1].value + numbers[i2].value + numbers[i3].value
