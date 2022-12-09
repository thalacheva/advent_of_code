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

p part1(file)
