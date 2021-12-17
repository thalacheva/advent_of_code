def get_points
  points = []
  input = File.readlines('day9.txt', chomp: true)
  input.each do |line|
    points.push(line.chars.map(&:to_i))
  end

  points

  # [[2,1,9,9,9,4,3,2,1,0],
  # [3,9,8,7,8,9,4,9,2,1],
  # [9,8,5,6,7,8,9,8,9,2],
  # [8,7,6,7,8,9,6,7,8,9],
  # [9,8,9,9,9,6,5,6,7,8]]
end

def part1(points)
  risk = []
  x = points.length - 1
  y = points[0].length - 1

  for i in 0..x do
    for j in 0..y do
      if (j == 0 || points[i][j] < points[i][j-1]) &&
        (j == y || points[i][j] < points[i][j+1]) &&
        (i == 0 || points[i][j] < points[i-1][j]) &&
        (i == x || points[i][j] < points[i+1][j])
        risk.push(points[i][j] + 1)
      end
    end
  end

  risk.sum
end

def low_point?(points, i, j)
  x = points.length - 1
  y = points[0].length - 1

  (j == 0 || points[i][j] < points[i][j-1]) &&
  (j == y || points[i][j] < points[i][j+1]) &&
  (i == 0 || points[i][j] < points[i-1][j]) &&
  (i == x || points[i][j] < points[i+1][j])
end

def flow(points, i, j)
  x = points.length - 1
  y = points[0].length - 1

  left = j != 0 && points[i][j] < points[i][j-1] && points[i][j-1] != 9
  right = j != y && points[i][j] < points[i][j+1] && points[i][j+1] != 9
  up = i != 0 && points[i][j] < points[i-1][j] && points[i-1][j] != 9
  down = i != x && points[i][j] < points[i+1][j] && points[i+1][j] != 9
  points[i][j] = 9
  $elements.add({x: i, y:j})

  flow(points, i, j-1) if left
  flow(points, i+1, j) if down
  flow(points, i, j+1) if right
  flow(points, i-1, j) if up
end

def part2(points)
  real_points = get_points
  basins = []
  risks = []
  x = points.length - 1
  y = points[0].length - 1

  for i in 0..x do
    for j in 0..y do
      risks.push({x: i, y: j}) if low_point?(points, i, j)
    end
  end

  risks.each do |p|
    points = real_points
    $elements = Set.new
    flow(points, p[:x], p[:y])
    basins.push($elements.size)
  end

  basins.sort
end

# puts part1(get_points)
puts part2(get_points)
