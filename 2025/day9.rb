input = File.readlines('day9.txt', chomp: true).map { _1.split(',').map(&:to_i) }

def part1(input)
  max_area = 0
  for i in 0...input.size - 1
    for j in i + 1...input.size
      area = (input[i][0] - input[j][0] + 1).abs * (input[i][1] - input[j][1] + 1).abs
      max_area = area if area > max_area
    end
  end

  p max_area
end

areas = []
for i in 0...input.size - 1
  for j in i + 1...input.size
    area = (input[i][0] - input[j][0] + 1).abs * (input[i][1] - input[j][1] + 1).abs
    areas << {a: i, b: j, area: area}
  end
end

areas = areas.sort_by { _1[:area] }.reverse

def on_segment?(p, a, b)
  px, py = p
  ax, ay = a
  bx, by = b

  return py.between?([ay, by].min, [ay, by].max) if ax == bx && px == ax

  px.between?([ax, bx].min, [ax, bx].max) if ay == by && py == ay
end

$visited = {}
def winding_number?(point, polygon)
  return $visited[point] if $visited.key?(point)

  px, py = point
  winding_number = 0

  polygon.each_with_index do |a, i|
    b = polygon[(i + 1) % polygon.size]
    x1, y1 = a
    x2, y2 = b

    if on_segment?(point, a, b)
      $visited[p] = true
      return true
    end

    next if y1 == y2

    if y1 <= py && y2 > py
      winding_number += 1 if px < x1
    elsif y1 > py && y2 <= py
      winding_number -= 1 if px < x1
    end
  end

  inside = winding_number != 0
  $visited[p] = inside
  inside
end

def rectangle_inside?(a, b, input)
  x1, y1 = a
  x2, y2 = b
  x_min, x_max = [x1, x2].minmax
  y_min, y_max = [y1, y2].minmax

  for y in y_min..y_max
    return false if !winding_number?([x1, y], input)
    return false if !winding_number?([x2, y], input)
  end

  for x in x_min..x_max
    return false if !winding_number?([x, y1], input)
    return false if !winding_number?([x, y2], input)
  end

  true
end

found = false
i = 26956
while !found && i < areas.size
  # 4629351648 - too high, 1525957356 - too low
  a = areas[i][:a]
  b = areas[i][:b]
  p "#{i} of #{areas.size} for area #{areas[i]}"
  if rectangle_inside?(input[a], input[b], input)
    p areas[i][:area]
    found = true
  end

  i += 1
end
