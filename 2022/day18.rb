require 'pry'

cubes = File.readlines('day18.txt').map { |l| l.chomp.split(',').map(&:to_i) }

def common_side?(cube1, cube2)
  x1, y1, z1 = cube1
  x2, y2, z2 = cube2

  if x1 == x2 && y1 == y2 && (z1 - z2).abs == 1 ||
     x1 == x2 && (y1 - y2).abs == 1 && z1 == z2 ||
     (x1 - x2).abs == 1 && y1 == y2 && z1 == z2
    return true
  end

  return false
end

def find_surface(cubes)
  p "finding surface for #{cubes.length}"
  sides = 0
  counted_cubes = []
  cubes.each do |c1|
    cube_sides = 6
    counted_cubes.each do |c2|
      cube_sides -= 2 if common_side?(c1, c2)
    end
    sides += cube_sides
    counted_cubes << c1
  end

  p "found #{sides} sides"
  sides
end

def find_pocket(space, x, y, z, visited)
  return false if x == 0 || y == 0 || z == 0 || x == 19 || y == 19 || z == 19
  return [] if visited[x][y][z] || space[x][y][z] == 1

  visited[x][y][z] = true
  x1 = find_pocket(space, x + 1, y, z, visited)
  x2 = find_pocket(space, x - 1, y, z, visited)
  y1 = find_pocket(space, x, y + 1, z, visited)
  y2 = find_pocket(space, x, y - 1, z, visited)
  z1 = find_pocket(space, x, y, z + 1, visited)
  z2 = find_pocket(space, x, y, z - 1, visited)

  return false unless x1 && x2 && y1 && y2 && z1 && z2

  [[x, y, z]] + x1 + x2 + y1 + y2 + z1 + z2
end

def part2(cubes)
  space = Array.new(20) { Array.new(20) { Array.new(20) { 0 } } }
  cubes.each { |c| space[c[0]][c[1]][c[2]] = 1 }

  visited = Array.new(20) { Array.new(20) { Array.new(20) { false } } }
  pockets = []
  for x in 0..19 do
    for y in 0..19 do
      for z in 0..19 do
        if space[x][y][z] == 0 && !visited[x][y][z]
          pocket = find_pocket(space, x, y, z, visited)
          if pocket
            pockets << pocket
          end
        end
      end
    end
  end

  area = find_surface(cubes)
  p "area surface is #{area}"
  interior = 0
  p "found #{pockets.length} pockets"

  pockets.each { |p| interior += find_surface(p) }

  p "exterior surface is #{area - interior}"
end

part2(cubes)
