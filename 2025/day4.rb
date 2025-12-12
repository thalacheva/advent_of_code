$diagram = File.readlines('day4.txt')
$h = $diagram.length
$w = $diagram[0].length


def adjacent(i, j)
  adj = 0
  [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |dist|
    x = i + dist[0]
    y = j + dist[1]

    adj += 1 if x >= 0 && x < $h && y >= 0 && y < $w && $diagram[x][y] == '@'
  end

  adj
end

def part1
  removed = 0

  for i in 0...$h
    for j in 0...$w
      next if $diagram[i][j] != '@'

      removed += 1 if adjacent(i, j) < 4
    end
  end

  removed
end

def forklift
  marked = []

  for i in 0...$h
    for j in 0...$w
      next if $diagram[i][j] != '@'

      marked << [i, j] if adjacent(i, j) < 4
    end
  end

  marked.each do |c|
    $diagram[c[0]][c[1]] = '.'
  end

  marked.size
end

def part2
  total = 0

  loop do
    removed = forklift
    total += removed

    break if removed == 0
  end

  total
end

puts part1
puts part2
