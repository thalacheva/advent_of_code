plan = File.readlines('day18.txt').map(&:chomp)

def perimeter(plan)
  ground = Array.new(350) { Array.new(350) { '.' } }
  x, y = 150, 5
  ground[150][5] = '#'

  plan.each do |step|
    direction, meters, _ = step.split(' ')
    meters = meters.to_i
    case direction
    when 'U'
      for i in x - meters..x - 1
        ground[i][y] = '#'
      end
      x -= meters
    when 'D'
      for i in x + 1..x + meters
        ground[i][y] = '#'
      end
      x += meters
    when 'L'
      for j in y - meters..y - 1
        ground[x][j] = '#'
      end
      y -= meters
    when 'R'
      for j in y + 1..y + meters
        ground[x][j] = '#'
      end
      y += meters
    end
  end

  ground
end

def adjacent(i, j, n)
  adjacent = []
  adjacent << [i - 1, j] if i > 0
  adjacent << [i + 1, j] if i < n - 1
  adjacent << [i, j - 1] if j > 0
  adjacent << [i, j + 1] if j < n - 1

  adjacent
end

def traverse(ground, x, y)
  visited = [[x, y]]

  until visited.empty? do
    current = visited.shift

    next if ground[current[0]][current[1]] == '#' || ground[current[0]][current[1]] == 0

    ground[current[0]][current[1]] = 0
    visited += adjacent(current[0], current[1], 350)
  end
end

def area(ground)
  traverse(ground, 0, 0)

  ground.reduce(0) { |acc, row| acc += row.count('#') + row.count('.') }
end

def task1(plan)
  ground = perimeter(plan)
  puts area(ground)
end

def perimeter2(plan)
  p = []

  plan.each do |step|
    color = step.split(' ').last
    meters = color[2, 5].to_i(16)
    direction = color[-2].to_i

    case direction
    when 3 # Up
      p << [0, -meters]
    when 1 # Down
      p << [0, meters]
    when 2 # Left
      p << [-meters, 0]
    when 0 # Right
      p << [meters, 0]
    end
  end

  p
end

def area2(p)

end

