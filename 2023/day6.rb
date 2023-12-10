lines = File.readlines('day6.txt').map(&:chomp)
times = lines.first.scan(/\d+/).map(&:to_i)
distances = lines.last.scan(/\d+/).map(&:to_i)

def count_wins(time, distance)
  wins = 0
  for i in 1..time
    wins += 1 if i * (time - i) > distance
  end

  wins
end

def part1(times, distances)
  product = 1
  for i in 0...times.length
    product *= count_wins(times[i], distances[i])
  end

  product
end

# p part1(times, distances)

# i**2 - time*i + distance = 0
def part2(time, distance)
  d = Math.sqrt(time**2 - 4*distance).to_i
  x1 = (time + d) / 2
  x2 = (time - d) / 2

  x1 - x2
end

p part2(times.join.to_i, distances.join.to_i)


