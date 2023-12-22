map = File.readlines('day21.txt').map(&:chomp).map(&:chars)

def find_start(map)
  map.each_with_index do |row, y|
    row.each_with_index do |col, x|
      return [x, y] if col == 'S'
    end
  end
end

def adjacent(map, x, y)
  [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1]
  ].select do |x, y|
    map[y][x] != '#' && x >= 0 && y >= 0 && x < map[0].length && y < map.length
  end
end

def plot(map, current)
  map.each_with_index do |row, y|
    row.each_with_index do |col, x|
      if current.include?([x, y])
        print 'O'
      else
        print col
      end
    end
    puts
  end
  puts '----------------'
end

def part1(map)
  start = find_start(map)
  current = [start]

  for s in 1..64
    next_step = []
    current.each do |x, y|
      adjacent(map, x, y).each do |x, y|
        next_step << [x, y] unless next_step.include?([x, y])
      end
    end
    current = next_step
    # plot(map, current)
  end

  current.length
end

p part1(map)