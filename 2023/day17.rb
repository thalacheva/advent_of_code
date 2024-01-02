map = File.readlines('day17.txt').map(&:chomp).map { |l| l.chars.map(&:to_i) }
INFINITY = 1 << 64

def adjacent(n, i, j, directions)
  adjacent = []
  if directions.empty?
    adjacent << [i - 1, j, :up] if i > 0
    adjacent << [i + 1, j, :down] if i < n - 1
    adjacent << [i, j - 1, :left] if j > 0
    adjacent << [i, j + 1, :right] if j < n - 1

    return adjacent
  end

  case directions.last
  when :up
    adjacent << [i - 1, j, :up] if i > 0 && (directions.length < 3 || directions.last(3).uniq.length > 1)
    adjacent << [i, j - 1, :left] if j > 0
    adjacent << [i, j + 1, :right] if j < n - 1
  when :down
    adjacent << [i + 1, j, :down] if i < n - 1 && (directions.length < 3 || directions.last(3).uniq.length > 1)
    adjacent << [i, j - 1, :left] if j > 0
    adjacent << [i, j + 1, :right] if j < n - 1
  when :left
    adjacent << [i, j - 1, :left] if j > 0 && (directions.length < 3 || directions.last(3).uniq.length > 1)
    adjacent << [i - 1, j, :up] if i > 0
    adjacent << [i + 1, j, :down] if i < n - 1
  when :right
    adjacent << [i, j + 1, :right] if j < n - 1 && (directions.length < 3 || directions.last(3).uniq.length > 1)
    adjacent << [i - 1, j, :up] if i > 0
    adjacent << [i + 1, j, :down] if i < n - 1
  end

  adjacent
end

def dijkstra(map)
  n = map.size
  paths = Array.new(n) { Array.new(n) { [INFINITY, []] } }
  visited = []
  pq = [[0, 0, nil]]
  paths[0][0] = [0, []]

  until pq.empty?
    pq.sort_by! { |p| paths[p[0]][p[1]][0] }

    i, j, dir = pq.shift

    next if visited.include?([i, j, dir])

    visited << [i, j, dir]

    adjacent(n, i, j, paths[i][j][1]).each do |x, y, d|
      next if visited.include?([x, y, d])

      if paths[i][j][0] + map[x][y] < paths[x][y][0]
        paths[x][y] = [paths[i][j][0] + map[x][y], paths[i][j][1] + [d]]
      end

      pq << [x, y, d] unless pq.include?([x, y, d])
    end
  end

  p paths[n - 1][n - 1][0]
end

dijkstra(map)

def shortest_path_algorith(map)
  n = map.size
  d = Array.new(n) { Array.new(n) { INFINITY } }
  d[0][0] = 0

  p = Array.new(n) { Array.new(n) { nil } }

  for i in 0...n
    for j in 0...n
      last_directions = []
      current = p[i][j]
      step = 0
      while current && step < 3
        step += 1
        last_directions << current[2]
        current = p[current[0]][current[1]]
      end

      adjacent(n, i, j, last_directions).each do |x, y, direction|
        if d[i][j] + map[x][y] < d[x][y]
          d[x][y] = d[i][j] + map[x][y]
          p[x][y] = [i, j, direction]
        end
      end
    end
  end

  p d[map.length - 1][map.length - 1]
end

shortest_path_algorith(map)
