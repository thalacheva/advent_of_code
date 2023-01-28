require 'pry'

input = File.readlines('day24.txt').map(&:chomp).map { |r| r.split('') }
n = input.length
m = input[0].length

def empty_map(n, m, x, y)
  map = Array.new(n) { Array.new(m) }
  for i in 0..n - 1 do
    for j in 0..m - 1 do
      if x == i && y == j
        map[i][j] = ['E']
      elsif i == 0 && j == 1 || i == n - 1 && j == m - 2
        map[i][j] = ['.']
      elsif i == 0 || j == 0 || i == n - 1 || j == m - 1
        map[i][j] = ['#']
      else
        map[i][j] = ['.']
      end
    end
  end

  map
end

def draw(map)
  map.each do |row|
    row.each do |cell|
      print cell.length > 2 ? cell.length - 1 : cell[1] ? cell[1] : cell[0]
    end
    puts ''
  end
end

map = empty_map(n, m, 0, 1)
for i in 0..n - 1 do
  for j in 0..m - 1 do
    cell = input[i][j]
    map[i][j] << cell if cell == '<' || cell == '>' || cell == '^' || cell == 'v'
  end
end

def blizz(map, x, y)
  n = map.length
  m = map[0].length
  blizzards = Array.new(4) { Array.new(n) { Array.new(m) { '.' }}}
  for i in 1..n - 2 do
    for j in 1..m - 2 do
      map[i][j].each do |cell|
        case cell
        when '<'
          if j == 1
            blizzards[0][i][m-2] = '<'
          else
            blizzards[0][i][j-1] = '<'
          end
        when '>'
          if j == m - 2
            blizzards[1][i][1] = '>'
          else
            blizzards[1][i][j+1] = '>'
          end
        when '^'
          if i == 1
            blizzards[2][n-2][j] = '^'
          else
            blizzards[2][i-1][j] = '^'
          end
        when 'v'
          if i == n - 2
            blizzards[3][1][j] = 'v'
          else
            blizzards[3][i+1][j] = 'v'
          end
        end
      end
    end
  end

  map = empty_map(n, m, x, y)
  blizzards.each do |b|
    for i in 1..n - 2 do
      for j in 1..m - 2 do
        map[i][j] << b[i][j] if b[i][j] != '.'
      end
    end
  end

  map
end

def copy(map)
  Marshal.load(Marshal.dump(map))
end

def move(map, x, y, end_x, end_y, minute)
  return if $moments.include? "x=#{x}, y=#{y}, m=#{minute}"

  $moments << "x=#{x}, y=#{y}, m=#{minute}"

  n = map.length
  m = map[0].length
  return if (end_x - x).abs + (end_y - y).abs + minute > $min

  if x == end_x && y == end_y
    p "found route in #{minute} minutes"
    $min = minute
    return
  end

  map = blizz(map, x, y)

  if x < n - 2 && map[x+1][y].length == 1 && map[x+1][y][0] == '.'
    move(copy(map), x + 1, y, end_x, end_y, minute + 1)
  end

  if y < m - 2 && map[x][y+1].length == 1 && map[x][y+1][0] == '.'
    move(copy(map), x, y + 1, end_x, end_y, minute + 1)
  end

  if map[x][y].length == 1
    move(copy(map), x, y, end_x, end_y, minute + 1)
  end

  if x > 1 && map[x-1][y].length == 1 && map[x-1][y][0] == '.'
    move(copy(map), x - 1, y, end_x, end_y, minute + 1)
  end

  if y > 1 && map[x][y-1].length == 1 && map[x][y-1][0] == '.'
    move(copy(map), x, y - 1, end_x, end_y, minute + 1)
  end
end

# move(map, 0, 1, n - 2, m - 2, 1)
$min = 230
p "best time first trip #{$min} mins"
best_time = $min

$min.times do
  map = blizz(map, n - 1, m - 2)
end
$min = 251
$moments = []

# move(map, n - 1, m - 2, 1, 1, 1)
p "best time back trip #{$min} mins"
best_time += $min

$min.times do
  map = blizz(map, 0, 1)
end
$min = 300
$moments = []

move(map, 0, 1, n - 2, m - 2, 1)
p "best time second trip #{$min} mins"
best_time += $min

p "final best time is #{best_time}"
