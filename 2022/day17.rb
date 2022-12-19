require 'matrix'
require 'pry'

jets = File.read('day17.txt').chomp.chars

rocks = [
  [['.', '.', '@', '@', '@', '@', '.']],
  [['.', '.', '.', '@', '.', '.', '.'],
   ['.', '.', '@', '@', '@', '.', '.'],
   ['.', '.', '.', '@', '.', '.', '.']],
  [['.', '.', '@', '@', '@', '.', '.'],
   ['.', '.', '.', '.', '@', '.', '.'],
   ['.', '.', '.', '.', '@', '.', '.']],
  [['.', '.', '@', '.', '.', '.', '.'],
   ['.', '.', '@', '.', '.', '.', '.'],
   ['.', '.', '@', '.', '.', '.', '.'],
   ['.', '.', '@', '.', '.', '.', '.']],
  [['.', '.', '@', '@', '.', '.', '.'],
   ['.', '.', '@', '@', '.', '.', '.']]
]

def can_move?(tower, d)
  can_move = true
  indexes = Matrix[*tower].each_with_index.with_object([]) { |(e, i, j), arr| arr << [i, j] if e == '@' }
  indexes.each do |a|
    if a[0] + d[0] >= 0 && a[1] + d[1] >= 0 && a[1] + d[1] < 7
      b = tower[a[0] + d[0]][a[1] + d[1]]
      can_move = false if b == '#'
    else
      can_move = false
    end
  end

  can_move
end

def move(tower, d)
  indexes = Matrix[*tower].each_with_index.with_object([]) { |(e, i, j), arr| arr << [i, j] if e == '@' }
  new_indexes = indexes.map { |a| [a[0] + d[0], a[1] + d[1]] }
  indexes.each { |a| tower[a[0]][a[1]] = '.' }
  new_indexes.each { |a| tower[a[0]][a[1]] = '@' }
end

tower = []
j = 0
i = 0
p jets.length
while i < 2022 do
  rock = Marshal.load(Marshal.dump(rocks[i % 5]))
  unit = Array.new(3) { Array.new(7) { '.' } } + rock
  tower += unit
  i += 1
  p "i = #{i}"
  falling = true
  while falling do
    jet = jets[j % jets.length]
    if jet == '>'
      move(tower, [0, 1]) if can_move?(tower, [0, 1])
    elsif jet == '<'
      move(tower, [0, -1]) if can_move?(tower, [0, -1])
    end
    j += 1

    if can_move?(tower, [-1, 0])
      move(tower, [-1, 0])
      tower.pop if tower.last.select { |e| e == '.' }.length == 7
    else
      indexes = Matrix[*tower].each_with_index.with_object([]) { |(e, i, j), arr| arr << [i, j] if e == '@' }
      indexes.each { |a| tower[a[0]][a[1]] = '#' }
      falling = false
    end
  end

  if i % 5 == j % jets.length
    p "i=#{i}, j=#{j}, tower height is #{tower.height}"
  end
end

p "i = #{i}, j = #{j}"
p tower.length
