require 'pry'

INFINITY = 1 << 64
input = File.readlines('day16.txt')
Valve = Struct.new(:name, :rate, :valves, :open, :path, :visited)

valves = []
input.each do |line|
  rate = line.chomp.scan(/-?\d+/).map(&:to_i).first
  v = line.chomp.scan(/[A-Z]{2}/)
  valves << Valve.new(v[0], rate, v[1..-1], false, INFINITY, false)
end

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

$max_pressure = 0
$mins = 26
def move(valves, current, mins, pressure)
  rest = valves.select { |v| !v.open && v.rate > 0 }
  if mins > $mins || rest.length == 0
    $max_pressure = [$max_pressure, pressure].max
    return
  end

  dijkstra(valves, current)
  rest.each do |v|
    mins += v.path + 1
    v.open = true
    pressure += [$mins - mins, 0].max * v.rate
    move(valves, v, mins, pressure)
    dijkstra(valves, current)
    v.open = false
    pressure -= [$mins - mins, 0].max * v.rate
    mins -= v.path + 1
  end
end

def move2(valves, you, elephant, your_mins, elephant_mins, pressure)
  rest = valves.select { |v| !v.open && v.rate > 0 }
  if (your_mins > $mins && elephant_mins > $mins) || rest.length == 0
    $max_pressure = [$max_pressure, pressure].max
    return
  end

  rest.each do |v|
    if your_mins < $mins
      dijkstra(valves, you)
      your_mins += v.path + 1
      v.open = true
      pressure += [$mins - your_mins, 0].max * v.rate
      move2(valves, v, elephant, your_mins, elephant_mins, pressure)
      dijkstra(valves, you)
      v.open = false
      pressure -= [$mins - your_mins, 0].max * v.rate
      your_mins -= v.path + 1
    end

    if elephant_mins < $mins
      dijkstra(valves, elephant)
      elephant_mins += v.path + 1
      v.open = true
      pressure += [$mins - elephant_mins, 0].max * v.rate
      move2(valves, you, v, your_mins, elephant_mins, pressure)
      dijkstra(valves, elephant)
      v.open = false
      pressure -= [$mins - elephant_mins, 0].max * v.rate
      elephant_mins -= v.path + 1
    end
  end
end

start = valves.find { |v| v.name ==  'AA' }
# move(valves, start, 0, 0)
move2(valves, start, start, 0, 0, 0)
p "max pressure is #{$max_pressure}"
