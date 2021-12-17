# $octopuses = [[5,4,8,3,1,4,3,2,2,3],
#             [2,7,4,5,8,5,4,7,1,1],
#             [5,2,6,4,5,5,6,1,7,3],
#             [6,1,4,1,3,3,6,1,4,6],
#             [6,3,5,7,3,8,5,4,7,8],
#             [4,1,6,7,5,2,4,6,4,5],
#             [2,1,7,6,8,4,1,7,2,1],
#             [6,8,8,2,8,8,1,1,3,4],
#             [4,8,4,6,8,4,8,5,5,4],
#             [5,2,8,3,7,5,1,5,2,6]]

$octopuses = []
input = File.readlines('day11.txt', chomp: true)
input.each do |line|
  $octopuses.push(line.chars.map(&:to_i))
end

def increase(i, j)
  return if i < 0 || j < 0 || i > 9 || j > 9 || $octopuses[i][j] == -1

  $octopuses[i][j] += 1

  if $octopuses[i][j] > 9
    $octopuses[i][j] = -1
    increase(i - 1, j - 1)
    increase(i - 1, j)
    increase(i - 1, j + 1)
    increase(i, j - 1)
    increase(i, j + 1)
    increase(i + 1, j - 1)
    increase(i + 1, j)
    increase(i + 1, j + 1)
  end
end

def part1
  flashes = 0

  100.times do
    for i in 0..9 do
      for j in 0..9 do
        $octopuses[i][j] += 1
      end
    end

    for i in 0..9 do
      for j in 0..9 do
        increase(i, j) if $octopuses[i][j] > 9
      end
    end

    for i in 0..9 do
      for j in 0..9 do
        if $octopuses[i][j] == -1
          $octopuses[i][j] = 0
          flashes += 1
        end
      end
    end
  end

  flashes
end

def part2
  flashes = 0
  iteration = 0

  while flashes < 100
    flashes = 0
    iteration += 1

    for i in 0..9 do
      for j in 0..9 do
        $octopuses[i][j] += 1
      end
    end

    for i in 0..9 do
      for j in 0..9 do
        increase(i, j) if $octopuses[i][j] > 9
      end
    end

    for i in 0..9 do
      for j in 0..9 do
        if $octopuses[i][j] == -1
          $octopuses[i][j] = 0
          flashes += 1
        end
      end
    end
  end

  iteration
end

# puts part1
puts part2
