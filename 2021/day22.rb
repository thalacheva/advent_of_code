MAX = 50

def generate(cube)
  x, y, z = cube
  a = []
  for i in x[0]..x[1] do
    for j in y[0]..y[1] do
      for k in z[0]..z[1] do
        a << [i, j, k]
      end
    end
  end
  a
end

def part1
  instructions = File.readlines('day22.txt', chomp: true)
  cubes = []
  instructions.each do |line|
    x, y, z = line.scan(/=(-*\d+)..(-*\d+)/).each { |r| r.map!(&:to_i) }
    next unless [x, y, z].flatten.reduce(true) { |acc, el| el.between?(-MAX, MAX) && acc }

    on = line.start_with?('on')
    if on
      cubes += generate([x, y, z])
    else
      cubes -= generate([x, y, z])
    end
  end

  cubes.uniq.length
end

def substract(r1, r2)
  a, b = r1
  c, d = r2
  return nil if b < c || d < a
  return [c, b] if c.between?(a, b) && b < d
  return [a, d] if a.between?(c, d) && d < b
  return r2 if c.between?(a, b) && d.between?(a, b)
  return r1 if a.between?(c, d) && b.between?(c, d)
end

def intersection(cube1, cube2)
  cube3 = []
  cube1.each_with_index do |side, index|
    delta = substract(side, cube2[index])
    return nil if delta.nil?

    cube3 << delta
  end

  cube3
end

def volume(cube)
  x, y, z = cube
  (x[1] - x[0] + 1) * (y[1] - y[0] + 1) * (z[1] - z[0] + 1)
end

def add(cube, cubes)
  cubes.each do |c|
    d = intersection(c[:on], cube)
    add(d, c[:off]) if d
  end

  cubes << {
    on: cube,
    off: []
  }
end

def sum(cube)
  s = volume(cube[:on])
  return s if cube[:off].empty?

  cube[:off].each do |c|
    s -= sum(c)
  end

  s
end

def part2
  instructions = File.readlines('day22.txt', chomp: true)
  cubes = []

  instructions.each do |line|
    x, y, z = line.scan(/=(-*\d+)..(-*\d+)/).each { |r| r.map!(&:to_i) }
    new_cube = [x, y, z]
    on = line.start_with?('on')
    cubes.each do |cube|
      delta = intersection(cube[:on], new_cube)
      add(delta, cube[:off]) if delta
    end

    next unless on

    cubes << {
      on: new_cube,
      off: []
    }
  end

  cubes.reduce(0) { |sum, cube| sum + sum(cube) }
end

puts part2
