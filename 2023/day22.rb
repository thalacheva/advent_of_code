input = File.readlines('day22.txt').map(&:chomp)

Point = Struct.new(:x, :y, :z)
Node = Struct.new(:before, :after)

def parse(input)
  bricks = []
  input.each do |line|
    start, end_ = line.split('~')
    p1 = start.split(',').map(&:to_i)
    p2 = end_.split(',').map(&:to_i)
    bricks << [Point.new(*p1), Point.new(*p2)]
  end

  bricks
end

def move(snapshot, brick)
  z = brick[0].z
  moved = false

  while z > 1
    for x in brick[0].x..brick[1].x
      for y in brick[0].y..brick[1].y
        if snapshot[x][y][z-1] != 0
          return moved
        end
      end
    end

    if z == brick[1].z
      for x in brick[0].x..brick[1].x
        for y in brick[0].y..brick[1].y
          snapshot[x][y][z-1] = snapshot[x][y][z]
          snapshot[x][y][z] = 0
        end
      end
    else
      x = brick[0].x
      y = brick[0].y
      snapshot[x][y][z-1] = snapshot[x][y][brick[1].z]
      snapshot[x][y][brick[1].z] = 0
    end

    brick[0].z -= 1
    brick[1].z -= 1
    z -= 1
    moved = true
  end

  moved
end

bricks = parse(input)
max_x = bricks.map { |b| [b[0].x, b[1].x].max }.max
max_y = bricks.map { |b| [b[0].y, b[1].y].max }.max
max_z = bricks.map { |b| [b[0].z, b[1].z].max }.max
snapshot = Array.new(max_x + 1) { Array.new(max_y + 1) { Array.new(max_z + 1, 0) } }

bricks.each_with_index do |b, i|
  (b[0].x..b[1].x).each do |x|
    (b[0].y..b[1].y).each do |y|
      (b[0].z..b[1].z).each do |z|
        snapshot[x][y][z] = i + 1
      end
    end
  end
end

moved = Array.new(bricks.size, false)
bricks.each_with_index do |b, i|
  moved[i] = move(snapshot, b)
end

while moved.any?
  bricks.each_with_index do |b, i|
    moved[i] = move(snapshot, b)
  end
end

# for z in 0..146
#   p "-----------------z=#{z}------------------"
#   for x in 0..max_x
#     for y in 0..max_y
#       print snapshot[x][y][z].to_s.rjust(5)
#     end
#     puts
#   end
# end
# p "-----------------z=#{max_z}------------------"

graph = Array.new(bricks.size) { Node.new([], []) }
bricks.each_with_index do |b, i|
  before = []
  if b[0].z > 1
    for x in b[0].x..b[1].x
      for y in b[0].y..b[1].y
        b1 = snapshot[x][y][b[0].z - 1] - 1
        before << b1 if b1 >= 0
      end
    end
  end
  after = []
  for x in b[0].x..b[1].x
    for y in b[0].y..b[1].y
      b2 = snapshot[x][y][b[1].z + 1] - 1
      after << b2 if b2 >= 0
    end
  end
  graph[i].before = before.uniq
  graph[i].after = after.uniq
end

safe = []
dangerous = []
graph.each_with_index do |node, i|
  if node.after.all? { |j| graph[j].before.size > 1 }
    safe << i
  else
    dangerous << i
  end
end

# Part 1
p "Safe to disintegrate #{safe.count} bricks."

# Part 2
falling_counts = Array.new(bricks.size, 0)

dangerous.each do |i|
  falling = []
  queue = [i]

  while queue.any?
    j = queue.shift
    graph[j].after.each do |k|
      if graph[k].before.size == 1 || graph[k].before.all? { |l| falling.include?(l) }
        falling << k unless falling.include?(k)
        queue << k unless queue.include?(k)
      end
    end
  end

  falling_counts[i] = falling.count
  # p "For brick #{i} will fall #{falling.count} bricks."
end

p falling_counts.sum
