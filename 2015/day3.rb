input = File.open('day3.txt').first

def part1(instructions)
  houses = ['0,0']
  last_house = houses.last

  instructions.each do |c|
    next_house = last_house.split(',').map(&:to_i)
    case c
    when '^'
      next_house[0] += 1
    when 'v'
      next_house[0] -= 1
    when '>'
      next_house[1] += 1
    when '<'
      next_house[1] -= 1
    end

    next_house_str = next_house.join(',')
    houses << next_house_str unless houses.include? next_house_str
    last_house = next_house_str
  end

  houses.count
end

def part2(instructions)
  houses = ['0,0']
  santa_last_house = houses.last
  robo_last_house = houses.last

  instructions.each_with_index do |c, i|
    last_house = i.even? ? santa_last_house : robo_last_house
    next_house = last_house.split(',').map(&:to_i)
    case c
    when '^'
      next_house[0] += 1
    when 'v'
      next_house[0] -= 1
    when '>'
      next_house[1] += 1
    when '<'
      next_house[1] -= 1
    end

    next_house_str = next_house.join(',')
    houses << next_house_str unless houses.include? next_house_str

    if i.even?
      santa_last_house = next_house_str
    else
      robo_last_house = next_house_str
    end
  end

  houses.count
end

instructions = input.split('')

puts part1(instructions)
puts part2(instructions)
