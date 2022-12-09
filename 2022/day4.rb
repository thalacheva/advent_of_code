input = File.readlines('day4.txt')

full_overlaps = 0
overlaps = 0

input.each do |line|
  parts = line.split(',')
  a = parts[0].chomp.split('-').map(&:to_i)
  b = parts[1].chomp.split('-').map(&:to_i)
  full_overlaps += 1 if a[0] <= b[0] && a[1] >= b[1] || b[0] <= a[0] && b[1] >= a[1]
  overlaps += 1 if a[0] <= b[0] && b[0] <= a[1] || b[0] <= a[0] && a[0] <= b[1]
end

p full_overlaps
p overlaps
