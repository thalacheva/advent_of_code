# --- Day 24: Never Tell Me The Odds ---

input = File.readlines('day24.txt').map(&:chomp)

Hailstone = Struct.new(:x, :y, :z, :vx, :vy, :vz)

def parse(input)
  hailstones = []
  input.map do |line|
    x, y, z, vx, vy, vz = line.scan(/-?\d+/).map(&:to_i)
    hailstones << Hailstone.new(x, y, z, vx, vy, vz)
  end

  hailstones
end

def cross?(h1, h2)
  min = 200000000000000
  max = 400000000000000

  # new_x = h1.x + h1.vx * t1 == h2.x + h2.vx * t2
  # new_y = h1.y + h1.vy * t1 == h2.y + h2.vy * t2

  t2 = (h1.vx * (h2.y - h1.y) - h1.vy * (h2.x - h1.x)).to_f / (h1.vy * h2.vx - h2.vy * h1.vx)
  t1 = (h2.x + h2.vx * t2 - h1.x).to_f / h1.vx

  # puts "h1 #{h1}, h2 #{h2}"
  # puts "t1: #{t1}, t2: #{t2}"

  return false if t1 < 0 || t2 < 0

  cross_x = h1.x + h1.vx * t1
  cross_y = h1.y + h1.vy * t1

  # puts "cross_x: #{cross_x}, cross_y: #{cross_y}"
  # puts '-----------------'

  cross_x.between?(min, max) && cross_y.between?(min, max)
end

def part1(input)
  hailstones = parse(input)
  count = 0
  for i in 0...hailstones.length
    for j in i+1...hailstones.length
      count += 1 if cross?(hailstones[i], hailstones[j])
    end
  end

  p "#{count} hailstones intersect"
end

INFINITY = 1 << 64
def part2(input)
  t_min = 1
  t_max = 1000000
  hailstones = parse(input)
  xr, yr, zr = [0, INFINITY], [0, INFINITY], [0, INFINITY]


  hailstones.each do |h|
    xr[0] = [h.x + h.vx * t_min, xr[0]].max
    xr[1] = [[h.x + h.vx * t_max, xr[1]].min, 0].max
    yr[0] = [h.y + h.vy * t_min, yr[0]].max
    yr[1] = [[h.y + h.vy * t_max, yr[1]].min, 0].max
    zr[0] = [h.z + h.vz * t_min, zr[0]].max
    zr[1] = [[h.z + h.vz * t_max, zr[1]].min, 0].max
  end

  p "xr: #{xr}, yr: #{yr}, zr: #{zr}"
end

part2 input
