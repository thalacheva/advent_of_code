# n = File.readlines('day3.txt')
# gamma = ''
# epsilon = ''

# k = n[0].strip.length
# l = n.length

# for i in 0..(k - 1) do
#   s = 0
#   for j in 0..(l - 1) do
#     s += n[j][i].to_i
#   end
#   gamma += (s > l / 2 ? '1' : '0')
#   epsilon += (s > l / 2 ? '0' : '1')
# end

# puts gamma
# puts epsilon
# puts gamma.to_i(2)
# puts epsilon.to_i(2)
# puts gamma.to_i(2) * epsilon.to_i(2)

def most_common(array, pos)
  l = array.length
  sum = 0
  for i in 0..(l - 1) do
    sum += array[i][pos].to_i
  end
  sum >= l - sum ? '1' : '0'
end

def least_common(array, pos)
  l = array.length
  sum = 0
  for i in 0..(l - 1) do
    sum += array[i][pos].to_i
  end
  sum < l - sum ? '1' : '0'
end

def find_oxygen(a)
  array = a.map(&:clone)
  k = array[0].strip.length
  for i in 0..(k - 1) do
    bit = most_common(array, i)
    array.reject! { |x| x[i] != bit }
    return array[0] if array.length == 1
  end
end

def find_co2(a)
  array = a.map(&:clone)
  k = array[0].strip.length
  for i in 0..(k - 1) do
    bit = least_common(array, i)
    array.reject! { |x| x[i] != bit }
    return array[0] if array.length == 1
  end
end

# n = %w[00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010]
n = File.readlines('day3.txt')

oxygen = find_oxygen(n)
co2 = find_co2(n)

puts oxygen.to_i(2)
puts co2.to_i(2)
puts oxygen.to_i(2) * co2.to_i(2)
