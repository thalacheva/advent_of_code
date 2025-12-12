input = File.readlines('day5.txt', chomp: true)

def part1(input)
  ranges = []
  ids = []
  start_ids = false
  for line in input
    start_ids = line.strip == '' if start_ids == false
    if start_ids
      ids << line.to_i
    else
      ranges << line.split("-").map { _1.to_i }
    end
  end

  def check(id, ranges)
    for range in ranges
      if range[0] <= id && id <= range[1]
        return 1
      end
    end

    0
  end

  sum = 0
  for id in ids
    sum += check(id, ranges)
  end

  puts sum
end

def part2(input)
  ranges = []
  for line in input
    break if line.strip == ''

    ranges << line.split("-").map { _1.to_i }
  end

  ranges = ranges.sort_by { _1[0] }
  unified = [ranges.shift]
  for r in ranges
    added = false
    unified.each_with_index do |u, i|
      break if added

      if r[0] >= u[0] && r[1] <= u[1]
        added = true
      else
        u1 = false
        u1 = [r[0], u[1]] if r[0] < u[0] && r[1] <= u[1] && r[1] >= u[0]
        u1 = [u[0], r[1]] if r[0] >= u[0] && r[1] > u[1] && r[0] <= u[1]

        if u1
          unified[i] = u1
          added = true
        end
      end
    end

    unified << r unless added
  end

  for u in unified
    p "#{u[0]}-#{u[1]}"
  end

  p unified.reduce(0) { _1 + (_2[1] - _2[0] + 1) }
end

part2(input)
