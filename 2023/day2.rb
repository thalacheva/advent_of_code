games = File.readlines('day2.txt').map(&:chomp)

$max = {
  red: 12,
  green: 13,
  blue: 14,
}

def task1(lines)
  sum = 0

  lines.each do |line|
    a = line.split(':')
    id = a.first.scan(/\d+/).first.to_i

    positive = true
    a.last.split(';').each do |set|
      cubes = set.split(',')
      cubes.each do |cube|
        value, color = cube.split(' ')

        case color
        when 'red'
          positive = false if value.to_i > $max[:red]
        when 'green'
          positive = false if value.to_i > $max[:green]
        when 'blue'
          positive = false if value.to_i > $max[:blue]
        end
      end
    end
    sum += id if positive
  end

  sum
end

def task2(lines)
  sum = 0

  lines.each do |line|
    a = line.split(':')

    red = 0
    green = 0
    blue = 0
    a.last.split(';').each do |set|
      cubes = set.split(',')
      cubes.each do |cube|
        value, color = cube.split(' ')

        case color
        when 'red'
          red = [value.to_i, red].max
        when 'green'
          green = [value.to_i, green].max
        when 'blue'
          blue = [value.to_i, blue].max
        end
      end
    end
    sum += red*green*blue
  end

  sum
end

#  p task1(games)

p task2(games)
