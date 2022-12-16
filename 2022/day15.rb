input = File.readlines('day15.txt')

Point = Struct.new(:x, :y) do
  def distance(p)
    (x - p.x).abs + (y - p.y).abs
  end
end

def part1(input)
  sensors = []
  beacons = []
  min_x = 0
  max_x = 0

  input.each do |line|
    sx, sy, bx, by = line.chomp.scan(/-?\d+/).map(&:to_i)
    s = Point.new(sx, sy)
    b = Point.new(bx, by)
    dist = s.distance(b)
    min_x = [sx - dist, min_x].min
    max_x = [sx + dist, max_x].max
    sensors << s
    beacons << b
  end

  row = Array.new(max_x - min_x) { '.' }
  # y = 10
  y = 2000000

  sensors.each_with_index do |s, i|
    dx = s.distance(beacons[i]) - s.distance(Point.new(s.x, y))
    for i in (s.x - dx)..(s.x + dx) do
      row[i - min_x] = '#'
    end
  end

  beacons.each do |b|
    row[b.x - min_x] = 'B' if b.y == y
  end

  p row.count('#')
end

# part1(input)

def combine(r1, r2)
  [[r1[0], r2[0]].min, [r1[1], r2[1]].max]
end

def part2(input)
  sensors = []
  beacons = []
  # max = 20
  max = 4000000

  input.each do |line|
    sx, sy, bx, by = line.chomp.scan(/-?\d+/).map(&:to_i)
    sensors << Point.new(sx, sy)
    beacons << Point.new(bx, by)
  end

  for y in 0..max do
    row = []
    sensors.each_with_index do |s, i|
      d = s.distance(beacons[i])
      dy = s.distance(Point.new(s.x, y))
      next if d < dy
      dx = d - dy
      x1 = [s.x - dx, 0].max
      x2 = [s.x + dx, max].min
      n = []
      for i in 0..row.length - 1 do
        if row[i][0] <= x1 && x2 <= row[i][1]
          n << i
        elsif row[i][0] <= x1 && x1 <= row[i][1] && row[i][1] <= x2
          row[i][1] = x2
          n << i
        elsif x1 <= row[i][0] && row[i][0] <= x2 && x2 <= row[i][1]
          row[i][0] = x1
          n << i
        elsif x1 <= row[i][0] && row[i][1] <= x2
          row[i][0] = x1
          row[i][1] = x2
          n << i
        elsif row[i][1] + 1 == x1
          row[i][1] = x2
          n << i
        elsif row[i][0] + 1 == x2
          row[i][0] = x1
          n << i
        end
      end

      if n.length == 0
        row << [x1, x2]
      elsif n.length > 1
        for m in 1..n.length - 1 do
          r = row.slice!(n[m] - m + 1)
          row[n[0]] = combine(row[n[0]], r)
        end

      end
    end

    unless row.include?([0, max])
      p "y=#{y}"
      p row
    end
  end
end

part2(input)
