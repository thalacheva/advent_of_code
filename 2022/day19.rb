require 'pry'

input = File.readlines('day19.txt')
blueprints = []
Blueprint = Struct.new(:id, :ore, :clay, :obsidian, :geode, :max)

input.each do |line|
  numbers = line.chomp.scan(/-?\d+/).map(&:to_i)
  blueprints << Blueprint.new(numbers[0], numbers[1], numbers[2], [numbers[3], numbers[4]], [numbers[5], numbers[6]], 0)
end

def build_geode_robot(b, materials, robots)
  {
    materials: [
      materials[0] + robots[0] - b.geode[0],
      materials[1] + robots[1],
      materials[2] + robots[2] - b.geode[1],
      materials[3] + robots[3]],
    robots: [robots[0], robots[1], robots[2], robots[3] + 1]
  }
end

def build_obsidian_robot(b, materials, robots)
  {
    materials: [
      materials[0] + robots[0] - b.obsidian[0],
      materials[1] + robots[1] - b.obsidian[1],
      materials[2] + robots[2],
      materials[3] + robots[3]],
    robots: [robots[0], robots[1], robots[2] + 1, robots[3]]
  }
end

def build_clay_robot(b, materials, robots)
  {
    materials: [
      materials[0] + robots[0] - b.clay,
      materials[1] + robots[1],
      materials[2] + robots[2],
      materials[3] + robots[3]],
    robots: [robots[0], robots[1] + 1, robots[2], robots[3]]
  }
end

def build_ore_robot(b, materials, robots)
  {
    materials: [
      materials[0] + robots[0] - b.ore,
      materials[1] + robots[1],
      materials[2] + robots[2],
      materials[3] + robots[3]],
    robots: [robots[0] + 1, robots[1], robots[2], robots[3]]
  }
end

def dont_build_robot(b, materials, robots)
  {
    materials: [
      materials[0] + robots[0],
      materials[1] + robots[1],
      materials[2] + robots[2],
      materials[3] + robots[3]],
    robots: robots.dup
  }
end

def ore?(b, materials)
  b.ore <= materials[0]
end

def clay?(b, materials)
  b.clay <= materials[0]
end

def obsidian?(b, materials)
  b.obsidian[0] <= materials[0] && b.obsidian[1] <= materials[1]
end

def geode?(b, materials)
  b.geode[0] <= materials[0] && b.geode[1] <= materials[2]
end

def factory(b, mins, robots: , materials:)
  if mins == 0
    b.max = [materials[3], b.max].max
    return
  end

  ore = ore?(b, materials) && robots[0] < b.clay
  clay = clay?(b, materials) && robots[1] < b.obsidian[1]
  obsidian = obsidian?(b, materials) && robots[2] < b.geode[1]

  if geode?(b, materials)
    factory(b, mins - 1, build_geode_robot(b, materials, robots))
  else
    factory(b, mins - 1, build_ore_robot(b, materials, robots)) if ore
    factory(b, mins - 1, build_clay_robot(b, materials, robots)) if clay
    factory(b, mins - 1, build_obsidian_robot(b, materials, robots)) if obsidian
    factory(b, mins - 1, dont_build_robot(b, materials, robots))
  end
end

blueprints.each do |b|
  factory(b, 32, {robots: [1, 0, 0, 0], materials: [0, 0, 0, 0]})
  p "Blueprint #{b.id} opens #{b.max} geodes"
end

# p blueprints.sum { |b| b.id * b.max }
p blueprints.inject(1) { |product, b| product * b.max }
