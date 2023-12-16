platform = File.readlines('day14.txt').map(&:chomp)

def print(platform)
  platform.each do |row|
    puts row
  end
end

def roll_north(platform, row, column)
  row -= 1
  while row >= 0 && platform[row][column] == '.'
    platform[row][column] = 'O'
    platform[row + 1][column] = '.'
    row -= 1
  end
end

def roll_west(platform, row, column)
  column -= 1
  while column >= 0 && platform[row][column] == '.'
    platform[row][column] = 'O'
    platform[row][column + 1] = '.'
    column -= 1
  end
end

def roll_south(platform, row, column)
  row += 1
  while row < platform.length && platform[row][column] == '.'
    platform[row][column] = 'O'
    platform[row - 1][column] = '.'
    row += 1
  end
end

def roll_east(platform, row, column)
  column += 1
  while column < platform[0].length && platform[row][column] == '.'
    platform[row][column] = 'O'
    platform[row][column - 1] = '.'
    column += 1
  end
end

def tilt_north(platform)
  for column in 0...platform[0].length
    for row in 1...platform.length
      if platform[row][column] == 'O'
        roll_north(platform, row, column)
      end
    end
  end
end

def tilt_west(platform)
  for row in 0...platform.length
    for column in 1...platform[0].length
      if platform[row][column] == 'O'
        roll_west(platform, row, column)
      end
    end
  end
end

def tilt_south(platform)
  for column in 0...platform[0].length
    for row in (platform.length - 2).downto(0)
      if platform[row][column] == 'O'
        roll_south(platform, row, column)
      end
    end
  end
end

def tilt_east(platform)
  for row in 0...platform.length
    for column in (platform[0].length - 2).downto(0)
      if platform[row][column] == 'O'
        roll_east(platform, row, column)
      end
    end
  end
end

def cycle(platform)
  tilt_north(platform)
  tilt_west(platform)
  tilt_south(platform)
  tilt_east(platform)
end

def calc_load(platform)
  load = 0
  for i in 0...platform.length
    for j in 0...platform[0].length
      if platform[i][j] == 'O'
        load += platform.length - i
      end
    end
  end

  load
end

variants = [platform.map(&:clone)]
cycle(platform)
i = 1

until variants.include?(platform) do
  variants << platform.map(&:clone)
  cycle(platform)
  i += 1
end

first = variants.index(platform)
period = variants.length - first

p calc_load(variants[first...-1][(1000000000 - first) % period])
