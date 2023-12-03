schema = File.readlines('day3.txt').map(&:chomp)
Gear = Struct.new(:x, :y, :numbers)

def adjacent(x1, x2, y, max_x, max_y)
  adj = []
  if y > 0
    adj << [x1 - 1, y - 1] if x1 > 0
    (x1..x2).each { |x| adj << [x, y - 1] }
    adj << [x2 + 1, y - 1] if x2 < max_x
  end

  adj << [x1 - 1, y] if x1 > 0
  adj << [x2 + 1, y] if x2 < max_x

  if y < max_y
    adj << [x1 - 1, y + 1] if x1 > 0
    (x1..x2).each { |x| adj << [x, y + 1] }
    adj << [x2 + 1, y + 1] if x2 < max_x
  end

  adj
end

def task1(schema)
  sum = 0
  schema.each_with_index do |row, i|
    numbers = row.scan(/\d+/)
    current_index = 0
    numbers.each do |number|
      left_index = row.index(number, current_index)
      right_index = left_index + number.length - 1
      is_part = false

      adjacent(left_index, right_index, i, row.length - 1, schema.length - 1).each do |x, y|
        is_part = true if schema[y][x] != '.'
      end

      sum += number.to_i if is_part
      current_index = right_index + 1
    end
  end

  sum
end

def task2(schema)
  gears = []

  schema.each_with_index do |row, i|
    numbers = row.scan(/\d+/)
    current_index = 0
    numbers.each do |number|
      left_index = row.index(number, current_index)
      right_index = left_index + number.length - 1

      adjacent(left_index, right_index, i, row.length - 1, schema.length - 1).each do |x, y|
        if schema[y][x] == '*'
          added = false
          gears.each do |gear|
            if gear.x == x && gear.y == y
              gear.numbers << number.to_i
              added = true
              break
            end
          end

          gears << Gear.new(x, y, [number.to_i]) unless added
        end
      end

      current_index = right_index + 1
    end
  end

  sum = 0
  gears.each do |gear|
    sum += gear.numbers.inject(:*) if gear.numbers.length > 1
  end

  sum
end

p task2(schema)
