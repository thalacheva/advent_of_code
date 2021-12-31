input = File.readlines('day25.txt', chomp: true)
sea_cucumbers = input.map { |line| line.split('') }

def move_east(cuc)
  cuc_dup = cuc.map(&:dup)
  still_moving = false
  i = 0
  j = 0
  while i < cuc.length
    j = 0
    while j < cuc[0].length
      next_j = j < cuc[0].length - 1 ? j + 1 : 0
      if cuc[i][j] == '>' && cuc_dup[i][next_j] == '.'
        still_moving = true
        cuc[i][next_j] = '>'
        cuc[i][j] = '.'
        j += 2
      else
        j += 1
      end
    end
    i += 1
  end

  still_moving
end

def move_south(cuc)
  cuc_dup = cuc.map(&:dup)
  still_moving = false
  i = 0
  j = 0
  while j < cuc[0].length
    i = 0
    while i < cuc.length
      next_i = i < cuc.length - 1 ? i + 1 : 0
      if cuc[i][j] == 'v' && cuc_dup[next_i][j] == '.'
        still_moving = true
        cuc[next_i][j] = 'v'
        cuc[i][j] = '.'
        i += 2
      else
        i += 1
      end
    end
    j += 1
  end

  still_moving
end

step = 0
moving = true

while moving
  step += 1
  moving_east = move_east(sea_cucumbers)
  moving_south = move_south(sea_cucumbers)
  moving = moving_east || moving_south
end

sea_cucumbers.each { |row| puts row.join.to_s }
puts step
