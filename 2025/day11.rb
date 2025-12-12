$input = File.readlines('day11.txt', chomp: true).map do |line|
  d, list = line.split(': ')

  [d, list.split(' ')]
end.to_h

$ways = 0

def find_ways(current)
  if current === 'out'
    $ways += 1
    return
  end

  $input[current].each { find_ways(_1) }
end

# find_ways('you')
# puts $ways

class DAGPaths
  def initialize(graph)
    @graph = graph
    @nodes = graph.keys
    @topo = topological_sort
  end

  def topological_sort
    indeg = Hash.new(0)
    @graph.each do |u, nbrs|
      nbrs.each { |v| indeg[v] += 1 }
    end
    p indeg
    q = @nodes.select { |n| indeg[n] == 0 }
    order = []

    until q.empty?
      u = q.shift
      order << u
      (@graph[u] || []).each do |v|
        indeg[v] -= 1
        q << v if indeg[v] == 0
      end
    end

    order
  end

  def count_paths_from(source)
    dp = Hash.new(0)
    dp[source] = 1

    @topo.each do |u|
      next if dp[u] == 0
      (@graph[u] || []).each do |v|
        dp[v] += dp[u]
      end
    end
    dp
  end

  def paths_between(u, v)
    count_paths_from(u)[v]
  end
end


dag = DAGPaths.new($input)
p dag.paths_between('svr', 'fft') * dag.paths_between('fft', 'dac') * dag.paths_between('dac', 'out')
