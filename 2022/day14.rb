input = File.readlines('day14.txt')

def init(input)
  scan = Array.new(185) { Array.new(1000) {'.'} }
  input.each do |line|
    parts = line.chomp.split(' -> ')
    parts.each_cons(2) do |(a,b)|
      x1, y1 = a.split(',').map(&:to_i)
      x2, y2 = b.split(',').map(&:to_i)
      if x1 == x2
        min, max = [y1, y2].minmax
        for i in min..max do
          scan[i][x1] = '#'
        end
      elsif y1 == y2
        min, max = [x1, x2].minmax
        for i in min..max do
          scan[y1][i] = '#'
        end
      end
    end
  end

  # scan[0][115] = '+'

  return scan
end

def draw(scan)
  for i in 0..184 do
    for j in 0..999 do
      print scan[i][j]
    end
    puts ''
  end
end

def move(scan, i, j)
  return 'abyss' if i == 184
  return 'rest' if scan[i+1][j] != '.' && scan[i+1][j-1] != '.' && scan[i+1][j+1] != '.'

  scan[i][j] = '.'
  if scan[i+1][j] == '.'
    i += 1 while i < 184 && scan[i+1][j] == '.'
    scan[i][j] = '*'
    move(scan, i, j)
  elsif scan[i+1][j-1] == '.'
    scan[i+1][j-1] = '*'
    move(scan, i+1, j-1)
  elsif scan[i+1][j+1] == '.'
    scan[i+1][j+1] = '*'
    move(scan, i+1, j+1)
  end
end

def part1(input)
  scan = init(input)
  units = 0
  result = nil

  while result != 'abyss' do
    i = 1
    j = 500
    scan[i][j] = '*'
    result = move(scan, i, j)
    units += 1
  end

  draw(scan)
  p units - 1
end

def move2(scan, i, j)
  return 'rest' if scan[i+1][j] != '.' && scan[i+1][j-1] != '.' && scan[i+1][j+1] != '.'

  scan[i][j] = '.'
  if scan[i+1][j] == '.'
    i += 1 while scan[i+1][j] == '.'
    scan[i][j] = '*'
    move(scan, i, j)
  elsif scan[i+1][j-1] == '.'
    scan[i+1][j-1] = '*'
    move(scan, i+1, j-1)
  elsif scan[i+1][j+1] == '.'
    scan[i+1][j+1] = '*'
    move(scan, i+1, j+1)
  end
end

def part2(input)
  scan = init(input)
  for j in 0..999 do
    scan[184][j] = '#'
    # scan[11][j] = '#'
  end
  units = 0
  result = nil

  while scan[0][500] == '.' do
    i = 0
    j = 500
    scan[i][j] = '*'
    result = move(scan, i, j)
    units += 1
  end

  draw(scan)
  p units
end

# part1(input)
part2(input)
