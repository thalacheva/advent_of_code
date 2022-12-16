input = File.readlines('day16.txt')
Valve = Struct.new(:name, :rate, :valves)

valves = []

input.each do |line|
  rate = line.chomp.scan(/-?\d+/).map(&:to_i).first
  v = line.chomp.scan(/[A-Z]{2}/)
  valves << Valve.new(v[0], rate, v[1..-1])
end

pp valves
