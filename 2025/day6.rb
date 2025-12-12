input = File.readlines('day6.txt')

def part1(input)
  k = input.length - 1
  problems = []
  for i in 0...k
    problems << input[i].split(' ').map { _1.to_i }
  end

  problems << input.last.split(' ')

  n = problems[0].length
  sum = 0
  for i in 0...n
    operation = problems.last[i]
    operands = []
    for j in 0...k
      operands << problems[j][i]
    end

    sum += (operation == '+' ? operands.reduce(:+) : operands.reduce(:*))
  end

  p sum
end

# part1(input)

def part2(input)
  k = input.length - 1
  last = input.last
  x = last.rindex(/[+*]/)

  problems = []
  l = 0
  while l <= x
    operator_index = last.index(/[+*]/, l)
    operator = last[operator_index]
    r = l + 1
    r += 1 while last[r] == ' '
    r = input[2].length if r > x

    operands = []
    for i in l...r - 1
      str = ''
      for j in 0...k
        str += input[j][i]
      end

      operands << str.to_i
    end

    l = r
    problems << operands.concat([operator])
  end

  sum = 0

  for i in 0...problems.length
    operation = problems[i].last
    operands = problems[i][0...-1]

    sum += (operation == '+' ? operands.reduce(:+) : operands.reduce(:*))
  end

  p sum
end

part2(input)
