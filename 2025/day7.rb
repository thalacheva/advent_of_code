input = File.readlines('day7.txt', chomp: true).map { _1.split('') }

def print(input)
  input.each { puts _1.join }
  puts
end

def part1(diagram)
  x = diagram.first.index('S')
  y = 0
  beans = [x]
  splits = 0
  while y < diagram.size - 1
    y += 1
    beans.each do |i|
      if diagram[y][i] == '.'
        diagram[y][i] = '|'
      elsif diagram[y][i] == '^'
        isSplit = false
        if i > 0 && diagram[y][i - 1] == '.'
          diagram[y][i - 1] = '|'
          isSplit = true
        end

        if i < diagram[y].length - 1 && diagram[y][i + 1] == '.'
          diagram[y][i + 1] = '|'
          isSplit = true
        end

        splits += 1 if isSplit
      end

      beans = diagram[y].each_index.select { diagram[y][_1] == '|' }
    end
  end

  print(diagram)
  p splits
end

def part2(diagram)
  x = diagram.first.index('S')
  y = 0
  beans = Hash.new(0)
  beans[x] = 1
  while y < diagram.size - 1
    y += 1
    new_beans = Hash.new(0)
    beans.each do |i, count|
      if diagram[y][i] == '^'
        new_beans[i - 1] += count
        new_beans[i + 1] += count
        new_beans[i] = 0
      else
        new_beans[i] += count
      end
    end

    beans = new_beans
  end

  p beans.sum { _1[1] }
end

part2(input)
