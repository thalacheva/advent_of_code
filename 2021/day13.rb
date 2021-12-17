# points = [[6,10],
#   [0,14],
#   [9,10],
#   [0,3],
#   [10,4],
#   [4,11],
#   [6,0],
#   [6,12],
#   [4,1],
#   [0,13],
#   [10,12],
#   [3,4],
#   [3,0],
#   [8,4],
#   [1,10],
#   [2,14],
#   [8,10],
#   [9,0]]

input = File.readlines('day13.txt', chomp: true)
points = []
input.each do |line|
  points << line.split(',').map(&:to_i)
end

max_x = 0
max_y = 0

points.each do |point|
  max_x = point[0] if max_x < point[0]
  max_y = point[1] if max_y < point[1]
end

paper = Array.new(max_x + 1) { Array.new(max_y + 1) }

points.each do |point|
  paper[point[0]][point[1]] = '#'
end

def fold_y(paper, max_x, max_y, y)
  for j in y+1..max_y do
    for i in 0..max_x do
      paper[i][2 * y - j] = '#' if paper[i][j] == '#'
    end
  end

  y - 1
end

def fold_x(paper, max_x, max_y, x)
  for j in 0..max_y do
    for i in x+1..max_x do
      paper[2 * x - i][j] = '#' if paper[i][j] == '#'
    end
  end

  x - 1
end

def count(paper, max_x, max_y)
  dots = 0
  for i in 0..max_x do
    for j in 0..max_y do
      dots += 1 if paper[i][j] == '#'
    end
  end

  dots
end

# puts count(paper, max_x, fold_y(paper, max_x, max_y, 7))
# puts count(paper, fold_x(paper, max_x, max_y, 655), max_y)

folds = [['x', 655], ['y', 447], ['x', 327], ['y', 223], ['x', 163], ['y', 111],
         ['x', 81], ['y', 55], ['x', 40], ['y', 27], ['y', 13], ['y', 6]]

folds.each do |fold|
  max_x = fold_x(paper, max_x, max_y, fold[1]) if fold[0] == 'x'
  max_y = fold_y(paper, max_x, max_y, fold[1]) if fold[0] == 'y'
end

digits = []

for j in 0..max_y do
  digits[j] = ''
  for i in 0..max_x do
    digits[j] += paper[i][j] || '.'
  end
end

puts digits
