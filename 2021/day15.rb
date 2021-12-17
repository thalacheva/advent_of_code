# map = [[1,1,6,3,7,5,1,7,4,2],
#         [1,3,8,1,3,7,3,6,7,2],
#         [2,1,3,6,5,1,1,3,2,8],
#         [3,6,9,4,9,3,1,5,6,9],
#         [7,4,6,3,4,1,7,1,1,1],
#         [1,3,1,9,1,2,8,1,3,7],
#         [1,3,5,9,9,1,2,4,2,1],
#         [3,1,2,5,4,2,1,6,3,9],
#         [1,2,9,3,1,3,8,5,2,1],
#         [2,3,1,1,9,4,4,5,8,1]]
map = []
input = File.readlines('day15.txt', chomp: true)
input.each do |line|
  map.push(line.chars.map(&:to_i))
end

def find_big_map(map)
  m = map.length
  n = map[0].length
  big_map = Array.new(m * 5) { Array.new(n * 5) }

  for i in 0..m-1 do
    for j in 0..n-1 do
      for k in 0..4 do
        for l in 0..4 do
          new_value = (map[i][j] + k + l) % 9
          new_value = 9 if new_value == 0
          big_map[i + k * m][j + l * n] = new_value
          big_map[i + l * m][j + k * n] = new_value
        end
      end
    end
  end

  big_map
end

def safe?(x, y, m, n)
  x >= 0 && y >= 0 && x < m && y < n
end

def min_risk(map)
  dx = [1, 0, -1, 0]
  dy = [0, 1, 0, -1]
  m = map.length
  n = map[0].length
  risks = Array.new(m) { Array.new(n) { 999999999 } }
  visited = Array.new(m) { Array.new(n) { false } }
  risks[0][0] = 0
  pq = []
  pq << { x: 0, y: 0, risk: 0 }

  until pq.empty?
    pq.sort_by! { |p| -p[:risk] }
    cell = pq.pop
    x = cell[:x]
    y = cell[:y]

    next if visited[x][y]

    visited[x][y] = true

    for i in 0..dx.length-1 do
      next_x = x + dx[i]
      next_y = y + dy[i]
      if safe?(next_x, next_y, m, n) && !visited[next_x][next_y]
        risks[next_x][next_y] = [risks[next_x][next_y], risks[x][y] + map[next_x][next_y]].min
        pq << { x: next_x, y: next_y, risk: risks[next_x][next_y] }
      end
    end
  end

  risks[m - 1][n - 1]
end

puts min_risk(find_big_map(map))
