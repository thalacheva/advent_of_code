input = File.readlines('day2.txt')

paper = 0
ribbon = 0

input.each do |line|
  d = line.split('x').map(&:to_i)
  slack = 10e6
  x = 0
  y = 0
  for i in 0..2 do
    j = i == 2 ? 0 : i + 1
    if slack > d[i] * d[j]
      slack = d[i] * d[j]
      x = i
      y = j
    end
  end

  paper += 2 * d[0] * d[1] + 2 * d[1] * d[2] + 2 * d[2] * d[0] + slack
  ribbon += 2 * d[x] + 2 * d[y] + d[0] * d[1] * d[2]
end

puts "paper is  #{paper}"
puts "ribbon is #{ribbon}"
