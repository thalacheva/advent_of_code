lines = File.readlines('day8.txt').map(&:chomp)

instructions = lines.first
nodes = {}

for i in 2...lines.length
  a, b, c = lines[i].scan(/\w+/)
  nodes[a] = [b, c]
end

def task1(nodes, instructions)
  node = 'AAA'
  steps = 0

  while node != 'ZZZ'
    i = instructions[steps % instructions.length]
    node = i == 'L' ? nodes[node][0] : nodes[node][1]
    steps += 1
  end

  steps
end

def find_steps(node, nodes, instructions)
  steps = 0

  until node[-1] == 'Z'
    i = instructions[steps % instructions.length]
    node = i == 'L' ? nodes[node][0] : nodes[node][1]
    steps += 1
  end

  steps
end

def task2(nodes, instructions)
  current = nodes.keys.filter { |a| a[-1] == 'A' }
  steps = []

  current.each do |node|
    steps << find_steps(node, nodes, instructions)
  end

  p steps
  steps.reduce(1) { |acc, n| acc.lcm(n) }
end

# p task1(nodes, instructions)
p task2(nodes, instructions)
