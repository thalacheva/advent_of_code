# --- Day 11: Cosmic Expansion ---

universe = File.readlines('day11.txt').map(&:chomp).map { |line| line.split('') }

def expand(universe)
  i = 0
  while i < universe.length
    if universe[i].all? { |cell| cell == '.' }
      universe.insert(i, Array.new(universe[0].length) { '.' })
      i += 2
    else
      i += 1
    end
  end

  i = 0
  while i < universe[0].length
    if universe.all? { |row| row[i] == '.' }
      universe.each { |row| row.insert(i, '.') }
      i += 2
    else
      i += 1
    end
  end
end

def draw(universe)
  for i in 0...universe.length
    for j in 0...universe[i].length
      print universe[i][j]
    end

    puts
  end
end

def galaxies(universe)
  coords =[]
  for i in 0...universe.length
    for j in 0...universe[i].length
      coords << [i, j] if universe[i][j] == '#'
    end
  end

  coords
end

def distancies(universe)
  coords = galaxies(universe)
  sum = 0

  for i in 0...coords.length
    for j in i + 1...coords.length
      sum += (coords[i][0] - coords[j][0]).abs + (coords[i][1] - coords[j][1]).abs
    end
  end

  sum
end

def expand2(universe, n)
  distancies = Array.new(universe.length) { Array.new(universe[0].length) { 1 } }
  for i in 0...universe.length
    if universe[i].all? { |cell| cell == '.' }
      for j in 0...universe[i].length
        distancies[i][j] = n
      end
    end
  end

  for i in 0...universe[0].length
    if universe.all? { |row| row[i] == '.' }
      for j in 0...universe.length
        distancies[j][i] = n
      end
    end
  end

  distancies
end

def distancies2(universe, distancies)
  coords = galaxies(universe)
  sum = 0

  for i in 0...coords.length
    for j in i + 1...coords.length
      x1 = coords[i][0]
      x2 = coords[j][0]
      y1 = coords[i][1]
      y2 = coords[j][1]

      for l in [x1, x2].min + 1..[x1, x2].max
        sum += distancies[l][y1]
      end
      for k in [y1, y2].min + 1..[y1, y2].max
        sum += distancies[x2][k]
      end
    end
  end

  sum
end

distancies = expand2(universe, 1000000)
p distancies2(universe, distancies)



