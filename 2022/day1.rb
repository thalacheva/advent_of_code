input = File.readlines('day1.txt')

elfs = []
max = 0
current = 0
input.each do |line|
  if line.strip.empty?
    elfs << current
    max = current if max < current
    current = 0
  else
    current += line.to_i
  end
end

puts max

elfs.each_with_index do |_, i|
  elfs.each_with_index do |_, j|
    if elfs[i] > elfs[j]
      temp = elfs[i]
      elfs[i] = elfs[j]
      elfs[j] = temp
    end
  end
end

puts elfs
puts '--------'
puts elfs[0] + elfs[1] + elfs[2]
