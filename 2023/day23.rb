map = File.readlines('day23.txt').map(&:chomp).map(&:chars)

def adjacent(map, x, y)
  adj = []

  # case map[x][y]
  # when '.'
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dx, dy|
      next if !map[x + dx] || !map[x + dx][y + dy]
      next if map[x + dx][y + dy] == '#'

      adj << [x + dx, y + dy]
    end
  # when '>'
  #   adj << [x, y + 1]
  # when 'v'
  #   adj << [x + 1, y]
  # end

  adj
end

$paths = []
def all_paths(map, current, final, visited)
  return if visited.include?(current)

  if current == final
    p "found path: #{visited.length}"
    $paths << visited + [current]
  end

  adjacent(map, current[0], current[1]).each do |x, y|
    next if visited.include?([x, y])

    all_paths(map, [x, y], final, visited + [current])
  end
end

start = [0, map[0].index('.')]
final = [map.length - 1, map[map.length - 1].index('.')]

all_paths(map, start, final, [])
p "max is #{$paths.map(&:length).max - 1}"

