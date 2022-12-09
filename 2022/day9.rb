require 'set'

file = File.readlines('day9.txt')
Point = Struct.new(:x, :y) do
  def adj?(p)
    (x - p.x).abs < 2 && (y - p.y).abs < 2
  end
end

def part1(file)
  coords = Set.new
  tail = Point.new 0, 0
  head = Point.new 0, 0
  coords << tail

  file.each do |line|
    direction, steps = line.chomp.split(' ')
    case direction
    when 'R'
      for i in 1..steps.to_i do
        head.y += 1
        if !tail.adj?(head)
          tail.y += 1
          tail.x -= 1 if tail.x > head.x
          tail.x += 1 if tail.x < head.x
          coords << Point.new(tail.x, tail.y)
        end
      end
    when 'L'
      for i in 1..steps.to_i do
        head.y -= 1
        if !tail.adj?(head)
          tail.y -= 1
          tail.x -= 1 if tail.x > head.x
          tail.x += 1 if tail.x < head.x
          coords << Point.new(tail.x, tail.y)
        end
      end
    when 'U'
      for i in 1..steps.to_i do
        head.x -= 1
        if !tail.adj?(head)
          tail.x -= 1
          tail.y -= 1 if tail.y > head.y
          tail.y += 1 if tail.y < head.y
          coords << Point.new(tail.x, tail.y)
        end
      end
    when 'D'
      for i in 1..steps.to_i do
        head.x += 1
        if !tail.adj?(head)
          tail.x += 1
          tail.y -= 1 if tail.y > head.y
          tail.y += 1 if tail.y < head.y
          coords << Point.new(tail.x, tail.y)
        end
      end
    end
  end

  coords.size
end

# p part1(file)

def part2(file)
  tails = []
  coords = []
  for i in 0..9 do
    tails << Point.new(0, 0)
    coords << [Point.new(0, 0)]
  end

  file.each do |line|
    direction, steps = line.chomp.split(' ')
    case direction
    when 'R'
      for i in 1..steps.to_i do
        tails[0].y += 1
        coords[0] << Point.new(tails[0].x, tails[0].y)
        for j in 1..9 do
          move(tails[j - 1], tails[j], coords[j])
        end
      end
    when 'L'
      for i in 1..steps.to_i do
        tails[0].y -= 1
        coords[0] << Point.new(tails[0].x, tails[0].y)
        for j in 1..9 do
          move(tails[j - 1], tails[j], coords[j])
        end
      end
    when 'U'
      for i in 1..steps.to_i do
        tails[0].x -= 1
        coords[0] << Point.new(tails[0].x, tails[0].y)
        for j in 1..9 do
          move(tails[j - 1], tails[j], coords[j])
        end
      end
    when 'D'
      for i in 1..steps.to_i do
        tails[0].x += 1
        coords[0] << Point.new(tails[0].x, tails[0].y)
        for j in 1..9 do
          move(tails[j - 1], tails[j], coords[j])
        end
      end
    end

    # draw(coords)

  end

  coords.last.uniq.size
end

def move(head, tail, coords)
  if !tail.adj?(head)
    tail.x -= 1 if tail.x > head.x
    tail.x += 1 if tail.x < head.x
    tail.y -= 1 if tail.y > head.y
    tail.y += 1 if tail.y < head.y
    coords << Point.new(tail.x, tail.y)
  end
end

def draw(coords)
  arr = Array.new(30) { Array.new(30) }
  for i in 0..29 do
    for j in 0..29 do
      arr[i][j] = '.'
    end
  end

  arr[15][15] = 's'

  coords.each_with_index do |c, i|
    x = c.last.x
    y = c.last.y
    arr[x + 15][y + 15] = (i == 0 ? 'H' : i)
  end

  for i in 0..arr.length - 1 do
    for j in 0..arr[i].length - 1 do
      print arr[i][j]
    end
    puts ''
  end
end

p part2(file)
