# plane = Array.new(10) { Array.new(10) { 0 } }
# input = ["0,9 -> 5,9", "8,0 -> 0,8", "9,4 -> 3,4", "2,2 -> 2,1", "7,0 -> 7,4", "6,4 -> 2,0", "0,9 -> 2,9", "3,4 -> 1,4", "0,0 -> 8,8", "5,5 -> 8,2"]

plane = Array.new(1000) { Array.new(1000) { 0 } }
input = File.readlines('day5.txt', chomp: true)

class Line
  attr_accessor :start_point, :end_point

  def initialize(input)
     start_line, end_line = input.split("->")
     @start_point = start_line.split(",").map(&:to_i)
     @end_point = end_line.split(",").map(&:to_i)
  end

  def horizontal?
    @start_point[1] == @end_point[1]
  end

  def vertical?
    @start_point[0] == @end_point[0]
  end
end

lines = []
input.each { |element| lines.push(Line.new(element)) }

lines.each do |line|
  if line.horizontal?
    min_x = [line.start_point[0], line.end_point[0]].min
    max_x = [line.start_point[0], line.end_point[0]].max
    while min_x <= max_x
      plane[min_x][line.start_point[1]] += 1
      min_x += 1
    end
  elsif line.vertical?
    min_y = [line.start_point[1], line.end_point[1]].min
    max_y = [line.start_point[1], line.end_point[1]].max
    while min_y <= max_y
      plane[line.start_point[0]][min_y] += 1
      min_y += 1
    end
  else
    point = line.start_point
    x_delta = line.start_point[0] < line.end_point[0] ? 1 : -1
    y_delta = line.start_point[1] < line.end_point[1] ? 1 : -1
    puts "diagonal line #{line.start_point} -> #{line.end_point}"
    while point != line.end_point
      plane[point[0]][point[1]] += 1
      puts "incrementing #{point}"
      point[0] += x_delta
      point[1] += y_delta
    end

    plane[point[0]][point[1]] += 1
  end
end

overlaping_points = 0

for i in 0..(plane.length - 1) do
  for j in 0..(plane.length - 1) do
    overlaping_points += 1 if plane[i][j] > 1
  end
end

puts overlaping_points
