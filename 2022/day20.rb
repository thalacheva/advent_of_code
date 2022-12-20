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
  next if current.value % n == 0

  v = current.value % n + i + (current.value > 0 ? 1 : 0)
  m = v < 0 ? (n - 1 + v) % n : v % n
  m -= 1 if i < m || m == 0

  numbers.insert(m, numbers.delete_at(i))
  p "#{current.value} moves"
  p numbers.map(&:value)
end

zero = numbers.find_index { |n| n.value == 0 }
i1 = (zero + 1000) % n
i2 = (zero + 2000) % n
i3 = (zero + 3000) % n

p numbers[i1].value + numbers[i2].value + numbers[i3].value

