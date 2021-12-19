def add(a, b)
  '[' + a + ',' + b + ']'
end

def explode_index(a)
  brakets = 0
  i = 0
  while i < a.length
    brakets += 1 if a[i] == '['
    brakets -= 1 if a[i] == ']'
    if brakets >= 5
      i += 1 until number?(a[i])
      return i - 1 if a[i, 5].match(/\d+,\d+/)
    end
    i += 1
  end
  nil
end

def number?(a)
  a =~ /\d/
end

def explode(a, i)
  h = a.index(',', i)
  g = a.index(']', i)
  j = i
  j -= 1 while j > 0 && !number?(a[j])
  l = g
  l += 1 while l < a.length && !number?(a[l])
  left = a[i+1..h-1].to_i
  right = a[h+1..g-1].to_i

  if number?(a[l])
    m = l
    m += 1 while m < a.length && number?(a[m])
    n1 = a[l..m-1].to_i + right
    a[l..m-1] = n1.to_s
  end

  a[i..g] = '0'
  if number?(a[j])
    k = j
    k -= 1 while k > 0 && number?(a[k])
    n2 = a[k+1..j].to_i + left
    a[k+1..j] = n2.to_s
  end

  a
end

def split_index(a)
  i = 0
  while i < a.length - 1
    return i if number?(a[i]) && number?(a[i + 1])

    i += 1
  end

  nil
end

def split(a, i)
  if number?(a[i]) && number?(a[i + 1])
    j = i + 1
    j += 1 while number?(a[j])
    b = a[i..j-1].to_i
    a[i..j-1] = '[' + (b/2).to_s + ',' + (b/2 + b%2).to_s + ']'
  end

  a
end

def reduce(a)
  while explode_index(a) || split_index(a)
    i = explode_index(a)
    j = split_index(a)
    if i
      a = explode(a, i)
    elsif j
      a = split(a, j)
    end
  end

  a
end

def magnitude(a)
  i = a =~ /\d+,\d+/
  while i
    j = a.index(',', i)
    k = a.index(']', j)
    m = a[i..j-1].to_i * 3 + a[j+1..k-1].to_i * 2
    a[i-1..k] = m.to_s
    i = a =~ /\d+,\d+/
  end
  a
end

input = [
  "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
  "[[[5,[2,8]],4],[5,[[9,9],0]]]",
  "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
  "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
  "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
  "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
  "[[[[5,4],[7,7]],8],[[8,3],8]]",
  "[[9,3],[[9,9],[6,[4,9]]]]",
  "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
  "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"
]

# input = File.readlines('day18.txt', chomp: true)

# sum = input[0]
# i = 1

# while i < input.length
#   sum = reduce(add(sum, input[i]))
#   i += 1
# end

# puts sum
# puts magnitude(sum)
max_m = 0

input.each_with_index do |number1, i|
  input.each_with_index do |number2, j|
    if i != j
      max_m = [max_m, magnitude(reduce(add(number1, number2))).to_i].max
    end
  end
end

puts max_m
