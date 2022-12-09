def amend_size(arr, size)
  arr.each do |el|
    el[:size] += size
  end
end

input = File.readlines('day7.txt')
total = 0
dirs = []
stack = []
currenct_size = 0
input.each do |line|
  command = line.chomp
  if command.start_with?('$ cd')
    dir = command.split(' ')[2]
    if dir == '..'
      amend_size(stack, currenct_size)
      currenct_size = 0
      last = stack.pop
      dirs << last
      total += last[:size] if last[:size] <= 100000
    else
      amend_size(stack, currenct_size)
      currenct_size = 0
      stack << {name: dir, size:0}
    end
  elsif command == '$ ls'
  elsif command.start_with?('dir')
  else
    currenct_size += command.split(' ')[0].to_i
  end
end

amend_size(stack, currenct_size)
dirs.push(*stack)
total += currenct_size if currenct_size <= 100000
p dirs
p total

parent = dirs.find { |dir| dir[:name] == '/' }

total_space = 70000000
update_size = 30000000
unused = total_space - parent[:size]
needed = update_size - unused
p needed
dirs.sort_by! { |k| k[:size]}
i = 0
i += 1 while dirs[i][:size] < needed
p dirs[i][:size]
