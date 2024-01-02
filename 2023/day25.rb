input = File.readlines('day25.txt').map(&:chomp)

def parse(input)
  graph = Hash.new { |h, k| h[k] = [] }
  edges = []

  input.each do |line|
    a, b = line.split(': ')
    nodes = b.split(' ')

    if graph[a].empty?
      graph[a] = nodes
    else
      graph[a] += nodes
    end

    nodes.each do |n|
      graph[n] << a
      edges << [a, n]
    end
  end

  [graph, edges]
end

def bfs(graph, start)
  visited = []
  queue = [start]
  until queue.empty?
    node = queue.shift
    next if visited.include?(node)

    visited << node
    queue += graph[node]
  end

  visited
end

def disconected?(graph)
  visited = bfs(graph, graph.keys.first)
  graph.keys.length != visited.length
end

def remove_edge(graph, edge)
  node1, node2 = edge

  graph[node1].delete(node2)
  graph[node2].delete(node1)
end

def clone_graph(graph)
  graph_copy = Hash.new { |h, k| h[k] = [] }
  graph.each do |k, v|
    graph_copy[k] = v.dup
  end

  graph_copy
end

def part1(input)
  graph, edges = parse(input)
  p "graph has #{graph.keys.length} nodes and #{edges.length} edges"

  edges.combination(3).each do |e1, e2, e3|
    p "trying #{e1}, #{e2}, #{e3}"
    graph_copy = clone_graph(graph)
    remove_edge(graph_copy, e1)
    remove_edge(graph_copy, e2)
    remove_edge(graph_copy, e3)

    visited = bfs(graph_copy, graph_copy.keys.first)

    if graph_copy.keys.length != visited.length
      p "Found it! #{e1}, #{e2}, #{e3}"
      a = visited.length
      b = graph_copy.keys.length - visited.length
      p "part 1: #{a}, part 2: #{b}, result #{a * b}"
      return
    end
  end
end

part1 input
