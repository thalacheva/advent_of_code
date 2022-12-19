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

p sides
