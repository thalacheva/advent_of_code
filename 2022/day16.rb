require 'pry'

INFINITY = 1 << 64
input = File.readlines('day16.txt')
Valve = Struct.new(:name, :rate, :valves, :open, :path, :visited, :index)

valves = []
input.each_with_index do |line, index|
  rate = line.chomp.scan(/-?\d+/).map(&:to_i).first
  v = line.chomp.scan(/[A-Z]{2}/)
  valves << Valve.new(v[0], rate, v[1..-1], false, INFINITY, false, index)
end

$paths = Array.new(valves.length) { Array.new(valves.length) { 0 } }

def dijkstra(valves, start)
  valves.each do |v|
    v.path = INFINITY
    v.visited = false
  end

  start.path = 0
  pq = [start]

  until pq.empty?
    pq.sort_by! { |p| -p[:path] }
    valve = pq.pop

    next if valve.visited

    valve.visited = true
    valve.valves.each do |adjacent_name|
      adjacent = valves.find { |v| v.name == adjacent_name }
      adjacent.path = [adjacent.path, valve.path + 1].min
      pq << adjacent unless adjacent.visited
    end
  end
end

for i in 0..valves.length - 1 do
  dijkstra(valves, valves[i])
  for j in i..valves.length - 1 do
    $paths[i][j] = valves[j].path
    $paths[j][i] = valves[j].path
  end
end

# for i in 0..$paths.length-1 do
#   for j in 0..$paths.length-1 do
#     print $paths[i][j]
#   end
#   puts ''
# end

$max_pressure = 0
$max_path = []
def move(valves, current, mins, pressure, max_mins, path)
  path << current.name
  rest = valves.select { |v| !v.open && v.rate > 0 }
  if mins > max_mins || rest.length == 0
    if ($max_pressure < pressure)
      $max_pressure = pressure
      $max_path = path
    end

    return
  end

  rest.sort_by { |v| $paths[v.index][current.index].to_f / v.rate }.first(2).each do |v|
    distance = $paths[v.index][current.index]
    mins += distance + 1
    v.open = true
    pressure += [max_mins - mins, 0].max * v.rate
    move(valves, v, mins, pressure, max_mins, path.dup)
    v.open = false
    pressure -= [max_mins - mins, 0].max * v.rate
    mins -= distance + 1
  end
end

def move2(valves, you, elephant, your_mins, elephant_mins, pressure, max_mins)
  rest = valves.select { |v| !v.open && v.rate > 0 }
  if (your_mins > max_mins && elephant_mins > max_mins) || rest.length == 0
    puts pressure if pressure > 2800
    $max_pressure = [$max_pressure, pressure].max
    return
  end

  rest.sort_by { |vv| $paths[vv.index][you.index].to_f / vv.rate }.first(3).each do |your_next|
    if your_mins < max_mins
      distance = $paths[your_next.index][you.index]
      your_mins += distance + 1
      your_next.open = true
      pressure += [max_mins - your_mins, 0].max * your_next.rate
      move2(valves, your_next, elephant, your_mins, elephant_mins, pressure, max_mins)
      your_next.open = false
      pressure -= [max_mins - your_mins, 0].max * your_next.rate
      your_mins -= distance + 1
    end
  end

  rest.sort_by { |vv| $paths[vv.index][elephant.index].to_f / vv.rate }.first(3).each do |v|
    if elephant_mins < max_mins
      distance = $paths[v.index][elephant.index]
      elephant_mins += distance + 1
      v.open = true
      pressure += [max_mins - elephant_mins, 0].max * v.rate
      move2(valves, you, v, your_mins, elephant_mins, pressure, max_mins)
      v.open = false
      pressure -= [max_mins - elephant_mins, 0].max * v.rate
      elephant_mins -= distance + 1
    end
  end
end

start = valves.find { |v| v.name ==  'AA' }
# move(valves, start, 0, 0, 30, [])
move2(valves, start, start, 0, 0, 0, 26)
p "max pressure is #{$max_pressure}"
p "path is #{$max_path}"
