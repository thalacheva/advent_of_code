contraption = File.readlines('day16.txt').map(&:chomp).map(&:chars)

def move(contraption, x, y, direction, visited)
  x1, y1 =
    if direction == 'right'
      [x, y + 1]
    elsif direction == 'left'
      [x, y - 1]
    elsif direction == 'up'
      [x - 1, y]
    elsif direction == 'down'
      [x + 1, y]
    end

  if x1 >= 0 && y1 >= 0 && x1 < contraption.size && y1 < contraption.size && visited[x1][y1] != direction
    visited[x1][y1] = direction

    if contraption[x1][y1] == '.'
      move(contraption, x1, y1, direction, visited)
    elsif contraption[x1][y1] == '\\'
      d1 =
        if direction == 'right'
          'down'
        elsif direction == 'left'
          'up'
        elsif direction == 'up'
          'left'
        elsif direction == 'down'
          'right'
        end
      move(contraption, x1, y1, d1, visited)
    elsif contraption[x1][y1] == '/'
      d1 =
        if direction == 'right'
          'up'
        elsif direction == 'left'
          'down'
        elsif direction == 'up'
          'right'
        elsif direction == 'down'
          'left'
        end
      move(contraption, x1, y1, d1, visited)
    elsif contraption[x1][y1] == '|'
      if direction == 'up' || direction == 'down'
        move(contraption, x1, y1, direction, visited)
      else
        move(contraption, x1, y1, 'up', visited)
        move(contraption, x1, y1, 'down', visited)
      end
    elsif contraption[x1][y1] == '-'
      if direction == 'left' || direction == 'right'
        move(contraption, x1, y1, direction, visited)
      else
        move(contraption, x1, y1, 'left', visited)
        move(contraption, x1, y1, 'right', visited)
      end
    end
  end
end

def plot(contraption, visited)
  visited.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if cell == '.'
        print contraption[i][j]
      elsif contraption[i][j] != '.'
        print contraption[i][j]
      elsif cell == 'right'
        print '>'
      elsif cell == 'left'
        print '<'
      elsif cell == 'up'
        print '^'
      elsif cell == 'down'
        print 'v'
      end
    end
    puts
  end
end

def start(contraption, x, y, direction)
  visited = Array.new(contraption.size) { Array.new(contraption.size) { '.' } }
  move(contraption, x, y, direction, visited)
  # plot(contraption, visited)
  visited.flatten.count { |x| x != '.' }
end

# p start(contraption, 0, -1, 'right')

max = 0
for i in 0...contraption.size
  max = [max, start(contraption, i, -1, 'right')].max
  max = [max, start(contraption, i, contraption.size, 'left')].max
  max = [max, start(contraption, -1, i, 'down')].max
  max = [max, start(contraption, contraption.size, i, 'up')].max
end

p max
