test_scanners = [
[
  [404,-588,-901],
  [528,-643,409],
  [-838,591,734],
  [390,-675,-793],
  [-537,-823,-458],
  [-485,-357,347],
  [-345,-311,381],
  [-661,-816,-575],
  [-876,649,763],
  [-618,-824,-621],
  [553,345,-567],
  [474,580,667],
  [-447,-329,318],
  [-584,868,-557],
  [544,-627,-890],
  [564,392,-477],
  [455,729,728],
  [-892,524,684],
  [-689,845,-530],
  [423,-701,434],
  [7,-33,-71],
  [630,319,-379],
  [443,580,662],
  [-789,900,-551],
  [459,-707,401]
],
[
  [686,422,578],
  [605,423,415],
  [515,917,-361],
  [-336,658,858],
  [95,138,22],
  [-476,619,847],
  [-340,-569,-846],
  [567,-361,727],
  [-460,603,-452],
  [669,-402,600],
  [729,430,532],
  [-500,-761,534],
  [-322,571,750],
  [-466,-666,-811],
  [-429,-592,574],
  [-355,545,-477],
  [703,-491,-529],
  [-328,-685,520],
  [413,935,-424],
  [-391,539,-444],
  [586,-435,557],
  [-364,-763,-893],
  [807,-499,-711],
  [755,-354,-619],
  [553,889,-390]
],
[
  [649,640,665],
  [682,-795,504],
  [-784,533,-524],
  [-644,584,-595],
  [-588,-843,648],
  [-30,6,44],
  [-674,560,763],
  [500,723,-460],
  [609,671,-379],
  [-555,-800,653],
  [-675,-892,-343],
  [697,-426,-610],
  [578,704,681],
  [493,664,-388],
  [-671,-858,530],
  [-667,343,800],
  [571,-461,-707],
  [-138,-166,112],
  [-889,563,-600],
  [646,-828,498],
  [640,759,510],
  [-630,509,768],
  [-681,-892,-333],
  [673,-379,-804],
  [-742,-814,-386],
  [577,-820,562]
],
[
  [-589,542,597],
  [605,-692,669],
  [-500,565,-823],
  [-660,373,557],
  [-458,-679,-417],
  [-488,449,543],
  [-626,468,-788],
  [338,-750,-386],
  [528,-832,-391],
  [562,-778,733],
  [-938,-730,414],
  [543,643,-506],
  [-524,371,-870],
  [407,773,750],
  [-104,29,83],
  [378,-903,-323],
  [-778,-728,485],
  [426,699,580],
  [-438,-605,-362],
  [-469,-447,-387],
  [509,732,623],
  [647,635,-688],
  [-868,-804,481],
  [614,-800,639],
  [595,780,-596]
],
[
  [727,592,562],
  [-293,-554,779],
  [441,611,-461],
  [-714,465,-776],
  [-743,427,-804],
  [-660,-479,-426],
  [832,-632,460],
  [927,-485,-438],
  [408,393,-506],
  [466,436,-512],
  [110,16,151],
  [-258,-428,682],
  [-393,719,612],
  [-211,-452,876],
  [808,-476,-593],
  [-575,615,604],
  [-485,667,467],
  [-680,325,-822],
  [-627,-443,-432],
  [872,-547,-609],
  [833,512,582],
  [807,604,487],
  [839,-516,451],
  [891,-625,532],
  [-652,-548,-490],
  [30,-46,-14]
]
]

def distance(v1, v2)
  [v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]]
end

def sum(v1, v2)
  [v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2]]
end

def minus(v)
  [-v[0], -v[1], -v[2]]
end

def rotate_vector(v, index)
  rotations = [
    [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1],
    [-1,2,3], [-1,3,2], [2,-1,3], [2,3,-1], [3,-1,2], [3,2,-1],
    [1,-2,3], [1,3,-2], [-2,1,3], [-2,3,1], [3,1,-2], [3,-2,1],
    [1,2,-3], [1,-3,2], [2,1,-3], [2,-3,1], [-3,1,2], [-3,2,1],
    [-1,-2,3], [-1,3,-2], [-2,-1,3], [-2,3,-1], [3,-1,-2], [3,-2,-1],
    [-1,2,-3], [-1,-3,2], [2,-1,-3], [2,-3,-1], [-3,-1,2], [-3,2,-1],
    [1,-2,-3], [1,-3,-2], [-2,1,-3], [-2,-3,1], [-3,1,-2], [-3,-2,1],
    [-1,-2,-3], [-1,-3,-2], [-2,-1,-3], [-2,-3,-1], [-3,-1,-2], [-3,-2,-1]
  ]

  rot = rotations[index]

  [
    rot[0] > 0 ? v[rot[0]-1] : -v[-rot[0]-1],
    rot[1] > 0 ? v[rot[1]-1] : -v[-rot[1]-1],
    rot[2] > 0 ? v[rot[2]-1] : -v[-rot[2]-1]
  ]
end

def rotate(s, index = nil)
  return s.map { |v| rotate_vector(v, index) } if index

  all = []
  48.times { |i| all << s.map { |v| rotate_vector(v, i) } }
  all
end

def move(beacons, dist)
  temp = []
  beacons.each do |b|
    temp << sum(dist, b)
  end

  temp
end

def check(s1, s2, i, j)
  rotate(s2).each_with_index do |r, index|
    for k in 0..s1.length - 1 do
      for l in 0..r.length - 1 do
        s1r = sum(s1[k], minus(r[l]))
        temp = move(r, s1r)
        common_beacons = temp & s1
        if common_beacons.length >= 12
          puts "common between #{i} and #{j}"
          return {
            distance: s1r,
            rotation: index,
            beacons: r - common_beacons
          }
        end
      end
    end
  end
  nil
end

def path(i, j, result, visited = [])
  return [i, j] if result[i][j]
  visited << i
  for k in 1..result.length-1 do
    if result[i][k] && !visited.include?(k)
      visited << k
      path = [i] + path(k, j, result, visited)
      return path if path.last == j
    end
  end
  [nil]
end

input = File.readlines('day19.txt', chomp: true)
scanners = []
current = nil
input.each do |line|
  if line.start_with?("--- scanner")
    scanners << current if current
    current = []
  elsif !line.chomp.empty?
    current << line.split(',').map(&:to_i)
  end
end
scanners << current if current
# scanners = test_scanners

result = Array.new(scanners.length) { Array.new(scanners.length) }
coordinates = Array.new(scanners.length)
coordinates[0] = [0, 0, 0]
beacons = scanners[0].dup

for i in 0..scanners.length - 1 do
  for j in 1..scanners.length - 1 do
    result[i][j] = check(scanners[i], scanners[j], i, j) if i != j
  end
end

for i in 1..result.length - 1 do
  path = path(0, i, result)

  if path && path.last == i
    puts "found path between 0 and #{i}: #{path}"
    p1 = path.pop
    p2 = path.pop
    temp = move(result[p2][p1][:beacons], result[p2][p1][:distance])
    coords = result[p2][p1][:distance].dup
    until path.empty?
      p1 = p2
      p2 = path.pop
      temp = move(rotate(temp, result[p2][p1][:rotation]), result[p2][p1][:distance])
      coords = sum(result[p2][p1][:distance], rotate_vector(coords, result[p2][p1][:rotation]))
    end
    beacons += temp
    coordinates[i] = coords
  else
    puts "No path found between 0 and #{i}"
  end
end

# puts beacons.uniq!.sort_by! { |b| b[0] }.to_s
puts "number of beacons: #{beacons.uniq.length}"

max_distance = 0
for i in 0..coordinates.length-1 do
  for j in i+1..coordinates.length-1 do
    v1 = coordinates[i]
    v2 = coordinates[j]
    distance = (v1[0] - v2[0]).abs + (v1[1] - v2[1]).abs + (v1[2] - v2[2]).abs
    max_distance = [max_distance, distance].max
  end
end

puts "max distance between scanners: #{max_distance}"
