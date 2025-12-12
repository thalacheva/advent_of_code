input = File.readlines('day8.txt', chomp: true).map { _1.split(',').map(&:to_i) }

def distance(a, b)
  (a[0] - b[0])**2 + (a[1] - b[1])**2 + (a[2] - b[2])**2
end

def distances(points)
  dd = []
  for i in 0...points.size - 1
    for j in i + 1...points.size
      dd << {a: i, b: j, d: distance(points[i], points[j])}
    end
  end

  return dd.sort_by { _1[:d] }
end

def normalize_circuits(circuits)
  for i in 0...circuits.size - 1
    for j in i + 1...circuits.size
      if circuits[i].intersect?(circuits[j])
        circuits[i] = circuits[i].union(circuits[j])
        circuits.delete_at(j)
        return normalize_circuits(circuits)
      end
    end
  end
end

def add_to_circuits(circuits, a, b)
  for circuit in circuits
    if circuit.include?(a)
      circuit.add(b)
      return
    elsif circuit.include?(b)
      circuit.add(a)
      return
    end
  end

  circuits << Set.new([a, b])
end

def part1(input)
  circuits = []
  distances(input)[0...1000].each do |entry|
    add_to_circuits(circuits, entry[:a], entry[:b])
    normalize_circuits(circuits)
  end

  sizes = circuits.map { _1.size }.sort
  p sizes[-1] * sizes[-2] * sizes[-3]
end

def part2(input)
  circuits = input.map.with_index { |_, i| Set.new([i]) }
  dd = distances(input)
  p dd.size
  i = 0
  while circuits.size > 1
    entry = dd[i]
    add_to_circuits(circuits, entry[:a], entry[:b])
    normalize_circuits(circuits)
    i += 1
    p i
  end

  p input[dd[i - 1][:a]][0] * input[dd[i - 1][:b]][0]
end

part2(input)
