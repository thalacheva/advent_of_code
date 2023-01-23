require 'pry'

numbers = File.readlines('day20.txt').map { |i| i.chomp.to_i }

def find_sum(numbers)
  n = numbers.length
  zero = numbers.find_index { |x| x == 0 }
  i1 = (zero + 1000) % n
  i2 = (zero + 2000) % n
  i3 = (zero + 3000) % n

  p "#{numbers[i1]}, #{numbers[i2]}, #{numbers[i3]}"
  numbers[i1] + numbers[i2] + numbers[i3]
end

def part1(numbers, original)
  n = numbers.length
  original.each do |current|
    next if current % (n - 1) == 0 || current == 0

    i = numbers.index(current)
    v = current.abs % (n - 1)
    v = -v if current < 0
    m = i + v
    m += n - 1 if m <= 0 && v < 0
    m -= n - 1 if m >= n && v > 0
    numbers.insert(m, numbers.delete_at(i))
    # p "moving #{v}"
    # p numbers.map {|v| v < 0 ? -(v.abs % (n - 1)) : v % (n - 1)}
  end

  numbers
end

def part2(numbers)
  key = 811589153
  n = numbers.length
  decrypted = numbers.map { |num| num * key }
  original = decrypted.dup
  p "Initial"
  p decrypted.map {|v| v < 0 ? -(v.abs % (n - 1)) : v % (n - 1)}

  10.times do |round|
    decrypted = part1(decrypted, original)
    p "round #{round + 1}"
    p decrypted.map {|v| v < 0 ? -(v.abs % (n - 1)) : v % (n - 1)}
    p decrypted
  end

  p find_sum(decrypted)
end

# part1(numbers, numbers.dup)
part2(numbers)
