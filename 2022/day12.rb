require 'pry'

lines = File.readlines('day12.txt')
map = []
lines.each do |line|
  row = line.chomp.split('')
  map << row
end
visited = Array.new(map.length) { Array.new(map[0].length) { false }}

def find_path(map, i, j, x, y, visited, path)
  p "#{map[i][j]}, #{i}, #{j}, #{path}"
  if i == x && j == y
    $min_path = path if path < $min_path
    return
  end

  visited[i][j] = true
  find_path(map, i, j - 1, x, y, visited, path + 1) if j > 0 && allowed?(map[i][j-1], map[i][j]) && !visited[i][j-1]
  find_path(map, i, j + 1, x, y, visited, path + 1) if j < map[0].length - 1 && allowed?(map[i][j+1], map[i][j]) && !visited[i][j+1]
  find_path(map, i - 1, j, x, y, visited, path + 1) if i > 0 && allowed?(map[i-1][j], map[i][j]) && !visited[i-1][j]
  find_path(map, i + 1, j, x, y, visited, path + 1) if i < map.length - 1 && allowed?(map[i+1][j], map[i][j]) && !visited[i+1][j]
  visited[i][j] = false
end

def allowed?(new_pos, old_pos)
  new_pos.ord <= old_pos.ord + 1
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

$min_path = map.length * map[0].length
find_path(map, si, sj, ei, ej, visited, 0)

p $min_path
