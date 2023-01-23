input = File.readlines('day19.txt')
blueprints = []
Blueprint = Struct.new(:id, :ore, :clay, :obsidian, :geode)

input.each do |line|
  numbers = line.chomp.scan(/-?\d+/).map(&:to_i)
  blueprints << Blueprint.new(numbers[0], numbers[1], numbers[2], [numbers[3], numbers[4]], [numbers[5], numbers[6]])
end

def build_geode_robot(b, materials, new_robots)
  if b.geode[0] <= materials[0] && b.geode[1] <= materials[2]
    new_robots[3] += 1
    materials[0] -= b.geode[0]
    materials[2] -= b.geode[1]
  end

  [materials, new_robots]
end

def build_obsidian_robot(b, materials, new_robots)
  if b.obsidian[0] <= materials[0] && b.obsidian[1] <= materials[1] && b.geode[1] > materials[2]
    new_robots[2] += 1
    materials[0] -= b.obsidian[0]
    materials[1] -= b.obsidian[1]
  end

  [materials, new_robots]
end

def build_clay_robot(b, materials, new_robots)
  if b.clay <= materials[0] && b.obsidian[1] > materials[1]
    new_robots[1] += 1
    materials[0] -= b.clay
  end

  [materials, new_robots]
end

def build_ore_robot(b, materials, new_robots)
  if b.ore <= materials[0] && new_robots[0] < new_robots[1] && new_robots[0] < new_robots[2] && new_robots[0] < new_robots[3]
    new_robots[0] += 1
    materials[0] -= b.ore
  end

  [materials, new_robots]
end

def factory(b)
  mins = 24
  robots = [1, 0, 0, 0]
  materials = [0, 0, 0, 0]

  for i in 1..24 do
    new_robots = [0, 0, 0, 0]
    materials, new_robots = build_geode_robot(b, materials, new_robots)
    materials, new_robots = build_obsidian_robot(b, materials, new_robots)
    materials, new_robots = build_clay_robot(b, materials, new_robots)
    materials, new_robots = build_ore_robot(b, materials, new_robots)

    robots.each_with_index { |r, i| materials[i] += r }
    new_robots.each_with_index { |r, i| robots[i] += r }
    p "minutes are #{i}"
    p "robots are #{robots}"
    p "materials are #{materials}"
    p "----------------------------"
  end

  materials[3]
end

blueprints.each do |b|
  geodes = factory(b)
  p "Blueprint #{b.id} opens #{geodes}"
end
