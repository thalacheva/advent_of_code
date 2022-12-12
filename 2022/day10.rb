lines = File.readlines('day10.txt')

def part1(lines)
  cycle = 0
  x = 1
  sum = 0

  lines.each do |line|
    command, value = line.chomp.split(' ')
    if command == 'noop'
      cycle += 1
      if [20, 60, 100, 140, 180, 220].include? cycle
        sum += cycle * x
        p "cycle #{cycle} value #{x}"
      end
    else
      cycle += 1
      if [20, 60, 100, 140, 180, 220].include? cycle
        sum += cycle * x
        p "cycle #{cycle} value #{x}"
      end
      cycle += 1
      if [20, 60, 100, 140, 180, 220].include? cycle
        sum += cycle * x
        p "cycle #{cycle} value #{x}"
      end
      x += value.to_i
    end
  end

  p sum
end

class CRT
  def initialize
    @cycle = 0
    @x = 1
    @crt = Array.new(6) { Array.new(40) { '.' } }
  end

  def execute(lines)
    lines.each do |line|
      command, value = line.chomp.split(' ')

      step
      next if command == 'noop'

      step
      @x += value.to_i
    end
  end

  def step
    @cycle += 1
    row = (@cycle - 1) / 40
    column = (@cycle - 1) % 40
    p "cycle #{@cycle}, x #{@x}, column #{column}"
    @crt[row][column] = @x - 1 <= column && column < @x + 2 ? '#' : '.'
    draw(@crt)
  end

  def draw(crt)
    for i in 0..5 do
      for j in 0..39 do
        print @crt[i][j]
      end
      puts ''
    end
  end
end

CRT.new.execute(lines)

