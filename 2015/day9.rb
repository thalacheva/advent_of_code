require 'set'

input = File.readlines('day9.txt')
towns = Set.new
Distance = Struct.new(:x, :y, :d)
$distances = []

input.each do |line|
  parts = line.split(' ')
  $distances << Distance.new(parts[0], parts[2], parts[4].to_i)
  towns << parts[0]
  towns << parts[2]
end

$min_path = 999999
$max_path = 0
def find_path(towns, current, path)
  towns.delete(current)
  if towns.empty?
    $min_path = [$min_path, path].min
    $max_path = [$max_path, path].max
    p "fount path with #{path}"
    return
  end

  towns.each do |town|
    distance = ($distances.find { |a| a.x == current && a.y == town || a.x == town && a.y == current }).d
    find_path(towns.dup, town, path + distance)
  end
end

towns.each do |town|
  find_path(towns.dup, town, 0)
end

p "Min path is #{$min_path}"
p "Max path is #{$max_path}"
