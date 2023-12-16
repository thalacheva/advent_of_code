input = File.readlines('day13.txt').map(&:chomp)

mirrors = []
current = []
input.each do |row|
  if row == ''
    mirrors << current
    current = []
  else
    current << row
  end
end
mirrors << current

def find_reflection(mirror)
  reflections = []
  for row in 0...mirror.length - 1
    size = [row, mirror.length - 2 - row].min

    if mirror[row - size..row].reverse == mirror[row + 1..row + 1 + size]
      reflections << (row + 1) * 100
    end
  end

  for column in 0...mirror[0].length - 1
    size = [column, mirror[0].length - 2 - column].min

    if mirror.map { |row| row[column - size..column].reverse } == mirror.map { |row| row[column + 1..column + 1 + size] }
      reflections << column + 1
    end
  end

  reflections.uniq
end

def toggle(mirror, row, column)
  mirror[row][column] = mirror[row][column] == '#' ? '.' : '#'
end

def find_reflection2(mirror)
  reflections = []
  for i in 0...mirror.length
    for j in 0...mirror[i].length
      test = Marshal.load(Marshal.dump(mirror))
      toggle(test, i, j)
      reflections += find_reflection(test)
    end
  end
  old = find_reflection(mirror)

  (reflections.uniq - old).first
end

total = 0
mirrors.each do |mirror|
  total += find_reflection2(mirror)
end

p total
