map = File.readlines('day17.txt').map(&:chomp).map { |l| l.chars.map(&:to_i) }
INFINITY = 1 << 64

def adjacent(n, i, j, directions)
  adjacent = []
  if directions.empty? || directions == [nil]
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

Path = Struct.new(:cost, :directions)

def dijkstra(map)
  n = map.size
  paths = Array.new(n) { Array.new(n) { Path.new(INFINITY, []) } }
  visited = []
  pq = [[0, 0, nil]]
  paths[0][0] = Path.new(0, [])

  until pq.empty?
    pq.sort_by! { |p| paths[p[0]][p[1]].cost }

    i, j, dir = pq.shift

    next if visited.include?([i, j, dir])

    visited << [i, j, dir]

    adjacent(n, i, j, paths[i][j].directions).each do |x, y, d|
      next if visited.include?([x, y, d])

      if paths[i][j].cost + map[x][y] < paths[x][y].cost
        paths[x][y] = Path.new(paths[i][j].cost + map[x][y], paths[i][j].directions + [d])
      end

      pq << [x, y, d] unless pq.include?([x, y, d])
    end
  end

  paths[n - 1][n - 1].cost
end

$min = dijkstra(map)
p "initial min: #{$min}"
def dfs(map, current, path, visited, goal)
  path << current
  visited[current[0]][current[1]] = true

  current_cost = path.map { |x, y, d| map[x][y] }.sum - map[0][0]
  return if current_cost >= $min

  if current[0] == goal[0] && current[1] == goal[1]
    p "found path with cost #{current_cost}"
    $min = current_cost
    return
  end

  adjacent(map.length, current[0], current[1], path.last(3).map { |c| c[2] }).sort_by { |x, y, d| map[x][y] * 10 - x - y }.each do |x, y, d|
    next if visited[x][y]

    dfs(map, [x, y, d], path.dup, Marshal.load(Marshal.dump(visited)), goal)
  end
end

def experiment(map)
  n = map.size
  visited = Array.new(n) { Array.new(n) { false } }

  dfs(map, [0, 0], [], visited, [n - 1, n - 1])
end

