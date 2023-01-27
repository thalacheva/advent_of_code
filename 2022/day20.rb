require 'pry'

Number = Struct.new(:value, :index)
numbers = File.readlines('day20.txt').map { |i| i.chomp.to_i }
# numbers = [1, 2, -3, 3, -2, 0, 4]

numbers = numbers.each_with_index.map { |x, i| Number.new(x, i) }

def find_sum(numbers)
  n = numbers.length
  zero = numbers.find_index { |x| x.value == 0 }
  i1 = (zero + 1000) % n
  i2 = (zero + 2000) % n
  i3 = (zero + 3000) % n

  p "#{numbers[i1].value}, #{numbers[i2].value}, #{numbers[i3].value}"
  numbers[i1].value + numbers[i2].value + numbers[i3].value
end

def part1(numbers, original)
  n = numbers.length
  original.each do |current|
    next if current.value % (n - 1) == 0

    i = numbers.find_index { |x| x.index == current.index }
    positions = current.value.abs % (n - 1)
    if current.value < 0
      j = i - positions
      j += n - 1 if j <= 0
    else
      j = i + positions
      j -= n - 1 if j >= n
    end

    numbers.insert(j, numbers.delete_at(i))
  end

  numbers
end

def part2(numbers)
  key = 811589153
  n = numbers.length
  decrypted = numbers.map { |x| Number.new(x.value * key, x.index) }
  original = decrypted.dup

  10.times do |round|
    decrypted = part1(decrypted, original)
  end

  p find_sum(decrypted)
end

# p find_sum(part1(numbers, numbers.dup))
part2(numbers)
