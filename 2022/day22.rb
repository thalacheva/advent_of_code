require 'pry'

path = File.readlines('day22path.txt', chomp: true).first.scan(/\d+[R|L]?/)
map = File.readlines('day22map.txt').map(&:chomp).map { |r| r.split('') }

def draw(map)
  map.each do |row|
    row.each do |cell|
      print cell
    end
    puts ''
  end
end

def password(current, direction)
  facing =
    case direction
    when 'right'
      0
    when 'down'
      1
    when 'left'
      2
    when 'up'
      3
    end

  p "x = #{current[0]}, y = #{current[1]}, direction = #{direction}, facing = #{facing}"
  (current[0] + 1) * 1000 + (current[1] + 1) * 4 + facing
end

def out?(map, i, j)
  i < 0 || i >= map.length || j < 0 || j >= map[i].length || map[i][j] == ' '
end

def free?(map, i, j)
  !out?(map, i, j) && map[i][j] != '#'
end

def go_left(map, start, tiles)
  i = start[0]
  j = start[1]
  while free?(map, i, j) && start[1] - j <= tiles do
    map[i][j] = '<'
    j -= 1
  end
  j += 1

  [i, j]
end

def go_right(map, start, tiles)
  i = start[0]
  j = start[1]
  while free?(map, i, j) && j - start[1] <= tiles do
    map[i][j] = '>'
    j += 1
  end
  j -= 1

  [i, j]
end

def go_up(map, start, tiles)
  i = start[0]
  j = start[1]
  while free?(map, i, j) && start[0] - i <= tiles do
    map[i][j] = '^'
    i -= 1
  end
  i += 1

  [i, j]
end

def go_down(map, start, tiles)
  i = start[0]
  j = start[1]
  while free?(map, i, j) && i - start[0] <= tiles do
    map[i][j] = 'v'
    i += 1
  end
  i -= 1

  [i, j]
end

def go(map, start, tiles, direction)
  case direction
  when 'right'
    return go_right(map, start, tiles)
  when 'left'
    return go_left(map, start, tiles)
  when 'up'
    return go_up(map, start, tiles)
  when 'down'
    return go_down(map, start, tiles)
  end
end

def clean(map)
  for i in 0..map.length - 1 do
    for j in 0..map[i].length - 1 do
      map[i][j] = '.' if map[i][j] == '>' || map[i][j] == '<' || map[i][j] == '^' || map[i][j] == 'v' || map[i][j] == 'C'
    end
  end
end

def rotate(direction, rotation)
  case direction
  when 'right'
    return rotation == 'R' ? 'down' : 'up'
  when 'left'
    return rotation == 'R' ? 'up' : 'down'
  when 'up'
    return rotation == 'R' ? 'right' : 'left'
  when 'down'
    return rotation == 'R' ? 'left' : 'right'
  end
end

def parse_tiles(path, step, index)
  if index < path.length - 1
    tiles = step[0..-2].to_i
    rotation = step[-1]
  else
    tiles = step.to_i
    rotation = nil
  end

  [tiles, rotation]
end

def part1(map, path)
  start = [0, map[0].index('.')]
  direction = 'right'
  current = start
  path.each_with_index do |step, index|
    tiles, rotation = parse_tiles(path, step, index)

    case direction
    when 'right'
      i, j = go_right(map, current, tiles)
      left_tiles = tiles - j + current[1] - 1
      if left_tiles > 0 && out?(map, i, j + 1)
        l = 0
        l += 1 while out?(map, i, l)
        i, j = go_right(map, [i, l], left_tiles) if map[i][l] != '#'
      end
    when 'left'
      i, j = go_left(map, current, tiles)
      left_tiles = tiles - current[1] + j - 1
      if left_tiles > 0 && out?(map, i, j - 1)
        l = map[i].length - 1
        i, j = go_left(map, [i, l], left_tiles) if map[i][l] != '#'
      end
    when 'up'
      i, j = go_up(map, current, tiles)
      left_tiles = tiles - current[0] + i - 1
      if left_tiles > 0 && out?(map, i - 1, j)
        k = map.length - 1
        k -= 1 while out?(map, k, j)
        i, j = go_up(map, [k, j], left_tiles) if map[k][j] != '#'
      end
    when 'down'
      i, j = go_down(map, current, tiles)
      left_tiles = tiles - i + current[0] - 1
      if left_tiles > 0 && out?(map, i + 1, j)
        k = 0
        k += 1 while out?(map, k, j)
        i, j = go_down(map, [k, j], left_tiles) if map[k][j] != '#'
      end
    end

    current = [i, j]
    map[i][j] = 'C'

    direction = rotate(direction, rotation) if rotation
  end

  password(current, direction)
end

def cube(i, j)
  if i >= 0 && i < 50 && j >= 50 && j < 100
    return {
      left: {coords: [100 + 49 - i, 0], direction: 'right'},
      up: {coords: [150 + j - 50, 0], direction: 'right'},
      right: {coords: [i, 100], direction: 'right'},
      down: {coords: [50, j], direction: 'down'},
    }
  elsif i >= 0 && i < 50 && j >= 100 && j < 150
    return {
      left: {coords: [i, 99], direction: 'left'},
      up: {coords: [199, j - 100], direction: 'up'},
      right: {coords: [149 - i, 99], direction: 'left'},
      down: {coords: [50 + j - 100, 99], direction: 'left'},
    }
  elsif i >= 50 && i < 100 && j >= 50 && j < 100
    return {
      left: {coords: [100, i - 50], direction: 'down'},
      up: {coords: [49, j], direction: 'up'},
      right: {coords: [49, 100 + i - 50], direction: 'up'},
      down: {coords: [100, j], direction: 'down'},
    }
  elsif i >= 100 && i < 150 && j >= 50 && j < 100
    return {
      left: {coords: [i, 49], direction: 'left'},
      up: {coords: [99, j], direction: 'up'},
      right: {coords: [149 - i, 149], direction: 'left'},
      down: {coords: [150 + j - 50, 49], direction: 'left'},
    }
  elsif i >= 100 && i < 150 && j >= 0 && j < 50
    return {
      left: {coords: [149 - i, 50], direction: 'right'},
      up: {coords: [50 + j, 50], direction: 'right'},
      right: {coords: [i, 50], direction: 'right'},
      down: {coords: [150, j], direction: 'down'},
    }
  elsif i >= 150 && i < 200 && j >= 0 && j < 50
    return {
      left: {coords: [0, i - 150 + 50], direction: 'down'},
      up: {coords: [149, j], direction: 'up'},
      right: {coords: [149, 50 + i - 150], direction: 'up'},
      down: {coords: [0, j + 100], direction: 'down'},
    }
  end
end

def small_cube(i, j)
  if i >= 0 && i < 4 && j >= 8 && j < 12
    return {
      left: {coords: [4, 4 + i], direction: 'down'},
      up: {coords: [4, 11 - j], direction: 'down'},
      right: {coords: [11 - i, 15], direction: 'left'},
      down: {coords: [4, j], direction: 'down'},
    }
  elsif i >= 4 && i < 8 && j >= 0 && j < 4
    return {
      left: {coords: [11, i + 8 ], direction: 'up'},
      up: {coords: [0, 11 - j], direction: 'down'},
      right: {coords: [i, 4], direction: 'right'},
      down: {coords: [11, 11 - j], direction: 'up'},
    }
  elsif i >= 4 && i < 8 && j >= 4 && j < 8
    return {
      left: {coords: [i, 3], direction: 'left'},
      up: {coords: [j - 4, 8], direction: 'right'},
      right: {coords: [i, 8], direction: 'right'},
      down: {coords: [4 + j, 8], direction: 'right'},
    }
  elsif i >= 4 && i < 8 && j >= 8 && j < 12
    return {
      left: {coords: [i, 7], direction: 'left'},
      up: {coords: [3, j], direction: 'up'},
      right: {coords: [8, 12 + 7 - i], direction: 'down'},
      down: {coords: [8, j], direction: 'down'},
    }
  elsif i >= 8 && i < 12 && j >= 8 && j < 12
    return {
      left: {coords: [7, i - 8 + 4], direction: 'up'},
      up: {coords: [7, j], direction: 'up'},
      right: {coords: [i, 12], direction: 'right'},
      down: {coords: [7, 11 - j], direction: 'up'},
    }
  elsif i >= 8 && i < 12 && j >= 12 && j < 16
    return {
      left: {coords: [i, 11], direction: 'left'},
      up: {coords: [4 + j - 12, 11], direction: 'left'},
      right: {coords: [11 - i, 11], direction: 'left'},
      down: {coords: [15 - j + 4, 0], direction: 'right'},
    }
  end
end

def go_next(map, i, j, direction, tiles)
  pos = cube(i,j)[:"#{direction}"]
  k, l = pos[:coords]
  if map[k][l] != '#'
    new_direction = pos[:direction]
    i1, j1 = go(map, [k, l], tiles, new_direction)
  end

  return [i1 || i, j1 || j, new_direction || direction]
end

def part2(map, path)
  start = [0, map[0].index('.')]
  direction = 'right'
  current = start
  path.each_with_index do |step, index|
    tiles, rotation = parse_tiles(path, step, index)
    # clean(map)

    case direction
    when 'right'
      i, j = go_right(map, current, tiles)
      left_tiles = tiles - (j + 1 - current[1])
      if left_tiles > 0 && out?(map, i, j + 1)
        i, j, new_direction = go_next(map, i, j, direction, left_tiles)
      end
    when 'left'
      i, j = go_left(map, current, tiles)
      left_tiles = tiles - (current[1] - (j - 1))
      if left_tiles > 0 && out?(map, i, j - 1)
        i, j, new_direction = go_next(map, i, j, direction, left_tiles)
      end
    when 'up'
      i, j = go_up(map, current, tiles)
      left_tiles = tiles - (current[0] - (i - 1))
      if left_tiles > 0 && out?(map, i - 1, j)
        i, j, new_direction = go_next(map, i, j, direction, left_tiles)
      end
    when 'down'
      i, j = go_down(map, current, tiles)
      left_tiles = tiles - (i + 1 - current[0])
      if left_tiles > 0 && out?(map, i + 1, j)
        i, j, new_direction = go_next(map, i, j, direction, left_tiles)
      end
    end

    current = [i, j]
    map[i][j] = 'C'
    if new_direction
      direction = new_direction
      # draw(map)
      # binding.pry
    end
    direction = rotate(direction, rotation) if rotation
  end

  password(current, direction)
end

p part2(map, path)
draw(map)
