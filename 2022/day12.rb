require 'pry'

lines = File.readlines('day12.txt')
map = []
lines.each do |line|
  row = line.chomp.split('')
  map << row
end

def safe?(map, x, y, next_x, next_y, m, n)
  # next_x >= 0 && next_y >= 0 && next_x < m && next_y < n && map[next_x][next_y].ord <= map[x][y].ord + 1
  next_x >= 0 && next_y >= 0 && next_x < m && next_y < n && map[x][y].ord <= map[next_x][next_y].ord + 1
end

def min_path(map, si, sj)
  dx = [1, 0, -1, 0]
  dy = [0, 1, 0, -1]
  m = map.length
  n = map[0].length
  dists = Array.new(m) { Array.new(n) { 999999999 } }
  visited = Array.new(m) { Array.new(n) { false } }
  dists[si][sj] = 0
  pq = []
  pq << { x: si, y: sj, dist: 0 }

  until pq.empty?
    pq.sort_by! { |p| -p[:dist] }
    cell = pq.pop
    x = cell[:x]
    y = cell[:y]

    next if visited[x][y]

    visited[x][y] = true

    for i in 0..dx.length-1 do
      next_x = x + dx[i]
      next_y = y + dy[i]
      if safe?(map, x, y, next_x, next_y, m, n) && !visited[next_x][next_y]
        dists[next_x][next_y] = [dists[next_x][next_y], dists[x][y] + 1].min
        pq << { x: next_x, y: next_y, dist: dists[next_x][next_y] }
      end
    end
  end

  dists
end

si = 0
sj = 0
ei = 0
ej = 0
for i in 0..map.length - 1 do
  for j in 0..map[i].length - 1 do
    if map[i][j] == 'S'
      si = i
      sj = j
      map[i][j] = 'a'
    end

    if map[i][j] == 'E'
      ei = i
      ej = j
      map[i][j] = 'z'
    end
  end
end

# dists = min_path(map, si, sj)
# p dists[ei][ej]

dists = min_path(map, ei, ej)
min_path = 999999999
for i in 0..map.length - 1 do
  for j in 0..map[i].length - 1 do
    min_path = dists[i][j] if map[i][j] == 'a' && dists[i][j] < min_path
  end
end

p min_path
