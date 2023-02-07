require 'pry'

lights = Array.new(1000) { Array.new(1000) { 0 }}

instructions = File.readlines('day6.txt').map(&:chomp)

def part1(lights, instructions)
  instructions.each do |line|
    a, b, c, d = line.scan(/\d+/).map(&:to_i)

    for i in b..d do
      for j in a..c do
        if line.start_with?('turn off')
          lights[i][j] = 0
        elsif line.start_with?('turn on')
          lights[i][j] = 1
        elsif line.start_with?('toggle')
          lights[i][j] = lights[i][j] == 1 ? 0 : 1
        end
      end
    end
  end

  on = 0
  for i in 0..999 do
    on += lights[i].count(1)
  end

  p on
end

def part2(lights, instructions)
  instructions.each do |line|
    a, b, c, d = line.scan(/\d+/).map(&:to_i)

    for i in b..d do
      for j in a..c do
        if line.start_with?('turn off') && lights[i][j] > 0
          lights[i][j] -= 1
        elsif line.start_with?('turn on')
          lights[i][j] += 1
        elsif line.start_with?('toggle')
          lights[i][j] += 2
        end
      end
    end
  end

  brightness = 0
  for i in 0..999 do
    brightness += lights[i].sum
  end

  p brightness
end

part2(lights, instructions)
