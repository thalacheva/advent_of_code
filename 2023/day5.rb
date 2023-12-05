lines = File.readlines('day5.txt').map(&:chomp)

def find_maps(lines)
  mappings = Array.new(7) { [] }
  current_map_index = 0

  lines[3...].each do |line|
    next if line === ''

    if line.include? 'map'
      current_map_index += 1
    else
      mappings[current_map_index] << line.split(' ').map(&:to_i)
    end
  end

  mappings
end

def task1(lines)
  seeds = lines.first.scan(/\d+/).map(&:to_i)

  find_maps(lines).each do |mapping|
    seeds.each_with_index do |seed, index|
      mapping.each do |map|
        if seed >= map[1] && seed < map[1] + map[2]
          seeds[index] = map[0] + seed - map[1]
          break
        end
      end
    end
  end

  seeds.min
end

def map(seed_ranges, mapping)
  new_seed_ranges = []
  mapped_seed_ranges = seed_ranges.dup
  seed_ranges.each_with_index do |seed_range, index|
    mapping.each do |map|
      if map[1] <= seed_range[0] && seed_range[0] < map[1] + map[2]
        if seed_range[0] + seed_range[1] <= map[1] + map[2]
          mapped_seed_ranges[index][0] = map[0] + seed_range[0] - map[1]
        else
          new_seed_ranges << [map[1] + map[2], seed_range[0] + seed_range[1] - map[1] - map[2]]
          mapped_seed_ranges[index] = [map[0] + seed_range[0] - map[1], map[1] + map[2] - seed_range[0]]
        end

        break
      elsif seed_range[0] < map[1] && map[1] < seed_range[0] + seed_range[1]
        if seed_range[0] + seed_range[1] <= map[1] + map[2]
          new_seed_ranges << [seed_range[0], map[1] - seed_range[0]]
          mapped_seed_ranges[index] = [map[0], seed_range[0] + seed_range[1] - map[1]]
        else
          new_seed_ranges << [seed_range[0], map[1] - seed_range[0]]
          new_seed_ranges << [map[1] + map[2], seed_range[0] + seed_range[1] - map[1] - map[2]]
          mapped_seed_ranges[index] = [map[0], map[2]]
        end

        break
      end
    end
  end

  [mapped_seed_ranges, new_seed_ranges]
end

def task2(lines)
  seed_ranges = lines.first.scan(/\d+/).map(&:to_i).each_slice(2).to_a

  mappings = find_maps(lines)

  mapped_seed_ranges = []
  new_seed_ranges = seed_ranges.dup
  mappings.each do |mapping|
    mapped_seed_ranges, new_seed_ranges = map(new_seed_ranges, mapping)

    while new_seed_ranges.length > 0
      a1, a2 = map(new_seed_ranges, mapping)
      mapped_seed_ranges += a1
      new_seed_ranges = a2
    end

    new_seed_ranges = mapped_seed_ranges.dup
  end

  mapped_seed_ranges.map(&:first).flatten.min
end

# p task1(lines)
p task2(lines)
