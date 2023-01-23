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
      left_tiles = tiles - j + current[1]
      if left_tiles > 0 && out?(map, i, j + 1)
        l = 0
        l += 1 while out?(map, i, l)
        i, j = go_right(map, [i, l], left_tiles) if map[i][l] != '#'
      end
    when 'left'
      i, j = go_left(map, current, tiles)
      left_tiles = tiles - current[1] + j
      if left_tiles > 0 && out?(map, i, j - 1)
        l = map[i].length - 1
        i, j = go_left(map, [i, l], left_tiles) if map[i][l] != '#'
      end
    when 'up'
      i, j = go_up(map, current, tiles)
      left_tiles = tiles - current[0] + i
      if left_tiles > 0 && out?(map, i - 1, j)
        k = map.length - 1
        k -= 1 while out?(map, k, j)
        i, j = go_up(map, [k, j], left_tiles) if map[k][j] != '#'
      end
    when 'down'
      i, j = go_down(map, current, tiles)
      left_tiles = tiles - i + current[0]
      if left_tiles > 0 && out?(map, i + 1, j)
        k = 0
        k += 1 while out?(map, k, j)
        i, j = go_down(map, [k, j], left_tiles) if map[k][j] != '#'
      end
    end

    current = [i, j]
    map[i][j] = 'C'

    # draw(map)
    # p "tiles #{tiles}, rotation #{rotation}, direction #{direction}"
    # binding.pry

    direction = rotate(direction, rotation) if rotation
  end

  password(current, direction)
end

def part2(map, path)
  start = [0, map[0].index('.')]
  direction = 'right'
  current = start
  path.each_with_index do |step, index|
    tiles, rotation = parse_tiles(path, step, index)

    case direction
    when 'right'
      i, j = go_right(map, current, tiles)
      left_tiles = tiles - j + current[1]
      if left_tiles > 0 && out?(map, i, j + 1)
        if j == 149 && i >= 0 && i < 50
          k = 149 - i
          l = 99
          if map[k][l] != '#'
            direction = 'left'
            i, j = go_left(map, [k, l], left_tiles)
          end
        elsif j == 99 && i >= 50 && i < 100
          k = 49
          l = 50 + i
          if map[k][l] != '#'
            direction = 'up'
            i, j = go_up(map, [k, l], left_tiles)
          end
        elsif j == 99 && i >= 100 && i < 150
          k = 149 - i
          l = 149
          if map[k][l] != '#'
            direction = 'left'
            i, j = go_left(map, [k, l], left_tiles)
          end
        elsif j == 49 && i >= 150 && i < 200
          k = 149
          l = i - 100
          if map[k][l] != '#'
            direction = 'up'
            i, j = go_up(map, [k, l], left_tiles)
          end
        end
      end
    when 'left'
      i, j = go_left(map, current, tiles)
      left_tiles = tiles - current[1] + j
      if left_tiles > 0 && out?(map, i, j - 1)
        if j == 50 && i >= 0 && i < 50
          k = 149 - i
          l = 0
          if map[k][l] != '#'
            direction = 'right'
            i, j = go_right(map, [k, l], left_tiles)
          end
        elsif j == 50 && i >= 50 && i < 100
          k = 100
          l = i - 50
          if map[k][l] != '#'
            direction = 'down'
            i, j = go_down(map, [k, l], left_tiles)
          end
        elsif j == 0 && i >= 100 && i < 150
          k = 149 - i
          l = 50
          if map[k][l] != '#'
            direction = 'right'
            i, j = go_right(map, [k, l], left_tiles)
          end
        elsif j == 0 && i >= 150 && i < 200
          k = 0
          l = i - 100
          if map[k][l] != '#'
            direction = 'down'
            i, j = go_down(map, [k, l], left_tiles)
          end
        end
      end
    when 'up'
      i, j = go_up(map, current, tiles)
      left_tiles = tiles - current[0] + i
      if left_tiles > 0 && out?(map, i - 1, j)
        if i == 100 && j >= 0 && j < 50
          k = 50 + j
          l = 50
          if map[k][l] != '#'
            direction = 'right'
            i, j = go_right(map, [k, l], left_tiles)
          end
        elsif i == 0 && j >= 50 && j < 100
          k = 100 + j
          l = 0
          if map[k][l] != '#'
            direction = 'right'
            i, j = go_right(map, [k, l], left_tiles)
          end
        elsif i == 0 && j >= 100 && j < 150
          k = 199
          l = j - 100
          if map[k][l] != '#'
            direction = 'up'
            i, j = go_up(map, [k, l], left_tiles)
          end
        end
      end
    when 'down'
      i, j = go_down(map, current, tiles)
      left_tiles = tiles - i + current[0]
      if left_tiles > 0 && out?(map, i + 1, j)
        if i == 49 && j >= 100 && j < 150
          k = j - 50
          l = 99
          if map[k][l] != '#'
            direction = 'left'
            i, j = go_left(map, [k, l], left_tiles)
          end
        elsif i == 149 && j >= 50 && j < 100
          k = 100 + j
          l = 49
          if map[k][l] != '#'
            direction = 'left'
            i, j = go_left(map, [k, l], left_tiles)
          end
        elsif i == 199 && j >= 0 && j < 50
          k = 0
          l = 100 + j
          if map[k][l] != '#'
            direction = 'down'
            i, j = go_down(map, [k, l], left_tiles)
          end
        end
      end
    end

    current = [i, j]
    map[i][j] = 'C'

    # draw(map)
    # p "tiles #{tiles}, rotation #{rotation}, direction #{direction}"
    # binding.pry

    direction = rotate(direction, rotation) if rotation
  end

  password(current, direction)
end

p part1(map, path)
draw(map)
