# --- Day 10: Pipe Maze ---
require 'colorize'

pipes = File.readlines('day10.txt').map(&:chomp).map { |line| line.split('') }

def print_map(pipes, loop)
  for i in 0...pipes.length
    for j in 0...pipes[i].length
      if loop.include?([i, j])
        print pipes[i][j].red
      else
        print pipes[i][j]
      end
    end

    puts
  end
end

def find_loop(pipes, start)
  visited = Array.new(pipes.length) { Array.new(pipes[0].length) { false } }
  loop = [start]

  while loop.length != 0 do
		current = loop[-1]
    current_pipe = pipes[current[0]][current[1]]

    if current_pipe == 'S' && loop.length > 3
      # p loop.length / 2
      return loop
    end

    visited[current[0]][current[1]] = true

    if ['|', 'L', 'J', 'S'].include?(current_pipe) && current[0] > 0 && ['|', 'F', '7', 'S'].include?(pipes[current[0] - 1][current[1]]) && (!visited[current[0] - 1][current[1]] || (pipes[current[0] - 1][current[1]] == 'S' && loop.length > 3))
      loop << [current[0] - 1, current[1]]
    elsif ['|', '7', 'F', 'S'].include?(current_pipe) && current[0] < pipes.length - 1 && ['|', 'L', 'J', 'S'].include?(pipes[current[0] + 1][current[1]]) && (!visited[current[0] + 1][current[1]] || (pipes[current[0] + 1][current[1]] == 'S' && loop.length > 3))
      loop << [current[0] + 1, current[1]]
    elsif ['-', '7', 'J', 'S'].include?(current_pipe) && current[1] > 0 && ['-', 'F', 'L', 'S'].include?(pipes[current[0]][current[1] - 1]) && (!visited[current[0]][current[1] - 1] || (pipes[current[0]][current[1] - 1] == 'S' && loop.length > 3))
      loop << [current[0], current[1] - 1]
    elsif ['-', 'F', 'L', 'S'].include?(current_pipe) && current[1] < pipes[current[0]].length - 1 && ['-', 'J', '7', 'S'].include?(pipes[current[0]][current[1] + 1]) && (!visited[current[0]][current[1] + 1] || (pipes[current[0]][current[1] + 1] == 'S' && loop.length > 3))
      loop << [current[0], current[1] + 1]
    else
      loop.pop
    end
	end
end

start = []
for i in 0...pipes.length
  for j in 0...pipes[i].length
    if pipes[i][j] == 'S'
      start = [i, j]
      break
    end
  end
end

loop = find_loop(pipes, start)

for i in 0...pipes.length
  for j in 0...pipes[i].length
    pipes[i][j] = '.' unless loop.include?([i, j]) || pipes[i][j] == 'S'
  end
end

for i in 0...pipes.length
  for j in 0...pipes[i].length
    next if ['-', '|', 'L', 'J', '7', 'F', 'S'].include?(pipes[i][j])

    count_left = 0
    k = -1
    last = nil
    while k < j
      k += 1

      next if pipes[i][k] == '.' || pipes[i][k] == '-'

      count_left += 1 if pipes[i][k] == '|'

      if pipes[i][k] == 'F'
        last = 'F'
        count_left += 1
      elsif pipes[i][k] == 'L'
        last = 'L'
        count_left += 1
      elsif pipes[i][k] == '7'
        count_left += 1 if last == 'F'
      elsif pipes[i][k] == 'J'
        count_left += 1 if last == 'L'
      end
    end

    if count_left.odd?
      pipes[i][j] = 'I'
    else
      pipes[i][j] = 'O'
    end
  end
end

print_map(pipes, loop)

total = 0
for i in 0...pipes.length
  total += pipes[i].count('I')
end

p total
