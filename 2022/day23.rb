require 'pry'

map = File.readlines('day23.txt').map { |l| l.chomp.chars }

Move = Struct.new(:start, :end)

def north?(map, i, j)
  return true if i == 0

  nw = j == 0 ? '.' : map[i-1][j-1]
  ne = j == map[i].length - 1 ? '.' : map[i-1][j+1]

  nw == '.' && map[i-1][j] == '.' && ne == '.'
end

def south?(map, i, j)
  return true if i == map.length - 1

  sw = j == 0 ? '.' : map[i+1][j-1]
  se = j == map[i].length - 1 ? '.' : map[i+1][j+1]

  sw == '.' && map[i+1][j] == '.' && se == '.'
end

def west?(map, i, j)
  return true if j == 0

  nw = i == 0 ? '.' : map[i-1][j-1]
  sw = i == map.length - 1 ? '.' : map[i+1][j-1]

  nw == '.' && map[i][j-1] == '.' && sw == '.'
end

def east?(map, i, j)
  return true if j == map[i].length - 1

  ne = i == 0 ? '.' : map[i-1][j+1]
  se = i == map.length - 1 ? '.' : map[i+1][j+1]

  ne == '.' && map[i][j+1] == '.' && se == '.'
end

def alone?(map, i, j)
  n = i == 0 ? '.' : map[i-1][j]
  nw = i == 0 || j == 0 ? '.' : map[i-1][j-1]
  w = j == 0 ? '.' : map[i][j-1]
  sw = i == map.length - 1 || j == 0 ? '.' : map[i+1][j-1]
  s = i == map.length - 1 ? '.' : map[i+1][j]
  se = i == map.length - 1 || j == map[i].length - 1 ? '.' : map[i+1][j+1]
  e = j == map[i].length - 1 ? '.' : map[i][j+1]
  ne = i == 0 || j == map[i].length - 1 ? '.' : map[i-1][j+1]

  [n, nw, w, sw, s, se, e, ne].all? { |d| d == '.' }
end

def remove_duplicates(moves)
  dups = []
  for i in 0..moves.length - 1 do
    for j in i + 1..moves.length - 1 do
      if moves[i].end == moves[j].end
        dups << i
        dups << j
      end
    end
  end
  dups.uniq.sort.reverse.each { |i| moves.delete_at(i) }

  moves
end

def find_moves(map, directions)
  moves = []
  for i in 0..map.length - 1 do
    for j in 0..map[i].length - 1 do
      next if map[i][j] == '.' || alone?(map, i, j)

      can_move = false
      directions.each do |d|
        case d
        when 'n'
          if north?(map, i , j)
            can_move = true
            moves << Move.new([i, j], [i - 1, j])
          end
        when 's'
          if south?(map, i, j)
            can_move = true
            moves << Move.new([i, j], [i + 1, j])
          end
        when 'w'
          if west?(map, i, j)
            can_move = true
            moves << Move.new([i, j], [i, j - 1])
          end
        when 'e'
          if east?(map, i, j)
            can_move = true
            moves << Move.new([i, j], [i, j + 1])
          end
        end

        break if can_move
      end
    end
  end
  remove_duplicates(moves)
end

def draw(map)
  map.each do |row|
    row.each do |cell|
      print cell
    end
    puts ''
  end
end

def add_row_north(map, moves)
  map.unshift(Array.new(map[0].length) { '.' })
  moves.each do |m|
    m.start[0] += 1
    m.end[0] += 1
  end
end

def add_row_south(map)
  map << Array.new(map[0].length) { '.' }
end

def add_row_east(map)
  map.each { |row| row << '.' }
end

def add_row_west(map, moves)
  map.each { |row| row.unshift('.') }
  moves.each do |m|
    m.start[1] += 1
    m.end[1] += 1
  end
end

def move(map, moves)
  moves.each do |move|
    add_row_north(map, moves) if move.end[0] < 0
    add_row_south(map) if move.end[0] > map.length - 1
    add_row_east(map) if move.end[1] > map[0].length - 1
    add_row_west(map, moves) if move.end[1] < 0
    map[move.start[0]][move.start[1]] = '.'
    map[move.end[0]][move.end[1]] = '#'
  end
end

def part1(map)
  directions = ['n', 's', 'w', 'e']
  10.times do |n|
    moves = find_moves(map, directions)
    move(map, moves)
    directions.rotate!
    # p "-------- round #{n+1} ---------"
    # draw(map)
  end

  draw(map)

  min_i = map.length
  max_i = -1
  min_j = map[0].length
  max_j = -1
  for i in 0..map.length - 1 do
    min = map[i].index('#')
    max = map[i].rindex('#')

    if min && max
      min_i = [min_i, i].min
      max_i = [max_i, i].max
      min_j = [min_j, min].min
      max_j = [max_j, max].max
    end
  end

  empty = 0
  for i in min_i..max_i do
    for j in min_j..max_j do
      empty += 1 if map[i][j] == '.'
    end
  end

  p empty
end

def part2(map)
  directions = ['n', 's', 'w', 'e']
  n = 1
  moves = find_moves(map, directions)
  while moves.length > 0
    move(map, moves)
    p n
    n += 1
    directions.rotate!
    moves = find_moves(map, directions)
  end

  p n
end

part2(map)
