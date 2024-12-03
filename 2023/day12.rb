# --- Day 12: Hot Springs ---
input = File.readlines('day12.txt').map(&:chomp)

def count(springs, groups)
  broken_indexes = (0...springs.length).find_all { |i| springs[i] == '#' }

  (0 ... springs.length).find_all { |i| springs[i] == '?'}.combination(groups.sum - springs.count('#')).
    count { |c| (c + broken_indexes).sort.slice_when { |prev, curr| curr != prev.next }.map(&:length) == groups }
end

def check(springs, groups)
  (0...springs.length).find_all { |i| springs[i] != '.' }.slice_when { |prev, curr| curr != prev.next }.map(&:length) == groups
end

def count2(springs, groups, index = 0, fpi = 0)
  count = 0
  current_group = groups[index]
  past_groups = groups[0...index]
  future_groups = groups[index+1..-1]

  x = 0
  ii = 0
  until x == past_groups.sum || ii >= springs.length
    x += 1 if springs[ii] == '#' || springs[ii] == '?'
    ii += 1
  end

  y = 0
  jj = springs.length - 1
  until y == future_groups.sum || jj < 0
    y += 1 if springs[jj] == '#' || springs[jj] == '?'
    jj -= 1
  end

  first_possible_index = [ii, past_groups.sum + past_groups.length, fpi].max
  last_possible_index = [jj, springs.length - current_group, springs.length - (future_groups.sum + future_groups.length) - 1].min

  for i in first_possible_index..last_possible_index
    copy = springs.dup
    possible = true
    for j in i...i+current_group
      if copy[j] == '.'
        possible = false
        break
      end

      copy[j] = '#'
    end

    next unless possible

    if i + current_group < copy.length && copy[i + current_group] != '#'
      copy[i + current_group] = '.'
    elsif i + current_group != copy.length
      next
    end

    for k in 0...i+current_group
      copy[k] = '.' if copy[k] == '?'
    end

    future = copy[i+current_group..-1]
    next if future.count('#') + future.count('?') < future_groups.sum
    next if future.length < future_groups.sum + future_groups.length
    next if copy.count('#') > groups.sum

    if index == groups.length - 1 || copy.count('?') == 0
      count += 1
    elsif copy.count('?') + copy.count('#') == groups.sum && check(copy, groups)
      count += 1
    elsif future.chars.all? { |c| c == '?' }
      freedom = future.length - future_groups.sum - future_groups.length
      n = future_groups.length + 1
      k = 1
      while k <= freedom && k <= n
        count += 1 if k == 1
        count += n + 1 if k == 2
        count += (0..n).to_a.combination(k).size if k > 2
      end
    else
      count += count2(copy, groups, index + 1, i + current_group + 1)
    end
  end

  count
end

def part1(input)
  input.sum do |row|
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)

    count2(springs, groups)
  end
end

def part2(input)
  output2 = File.readlines('output2.txt').map(&:chomp)
  output3 = File.readlines('output3.txt').map(&:chomp)
  index = 0
  input.sum do |row|
    springs, groups = row.split(' ')
    groups = groups.split(',').map(&:to_i)
    count2 = output2[index].split(' - ').last.to_i
    count3 = output3[index].split(' - ').last.to_i
    index += 1
    count = 0

    if count2 == count3
      count = count2
      p "#{index}: #{springs} - #{count2} - recorded"
    else
      count = count2(springs + '?' + springs + '?' + springs + '?' + springs + '?' + springs, groups + groups + groups + groups + groups)
      p "#{index}: #{springs} - #{count}"
    end

    count
  end
end

# p part1(input)
p part2(input)
