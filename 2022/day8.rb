lines = File.readlines('day8.txt')
forest = lines.map { |l| l.chomp.split('').map(&:to_i) }

count = 0
n = forest.length
m = forest[0].length

for i in 0..n - 1 do
  for j in 0..m - 1 do
    top = i
    bottom = i
    left = j
    right = j

    top -= 1 while top > 0 && forest[i][j] > forest[top - 1][j]
    bottom += 1 while bottom < n - 1 && forest[i][j] > forest[bottom + 1][j]
    left -= 1 while left > 0 && forest[i][j] > forest[i][left - 1]
    right += 1 while right < m - 1 && forest[i][j] > forest[i][right + 1]

    count += 1 if top == 0 || left == 0 || bottom == n - 1 || right == m - 1
  end
end

p count

max = 0
for i in 1..n - 2 do
  for j in 1..m - 2 do
    top = 1
    bottom = 1
    left = 1
    right = 1
    p "i=#{i}"
    p "j=#{j}"

    top += 1 until i - top == 0 || forest[i][j] <= forest[i - top][j]
    bottom += 1 until i + bottom == n - 1 || forest[i][j] <= forest[i + bottom][j]
    left += 1 until j - left == 0 || forest[i][j] <= forest[i][j - left]
    right += 1 until j + right == m - 1 || forest[i][j] <= forest[i][j + right]

    p "top=#{top}"
    p "bottom=#{bottom}"
    p "left=#{left}"
    p "right=#{right}"
    p "------------------"

    score = top * bottom * left * right
    max = score if max < score
  end
end

p max
