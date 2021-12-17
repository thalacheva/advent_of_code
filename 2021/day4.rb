numbers = [91,17,64,45,8,13,47,19,52,68,63,76,82,44,28,56,37,2,78,48,32,58,72,53,9,85,77,89,36,22,49,86,51,99,6,92,80,87,7,25,31,66,84,4,98,67,46,61,59,79,0,3,38,27,23,95,20,35,14,30,26,33,42,93,12,57,11,54,50,75,90,41,88,96,40,81,24,94,18,39,70,34,21,55,5,29,71,83,1,60,74,69,10,62,43,73,97,65,15,16]
input = File.readlines('day4.txt', chomp: true).reject { |s| s.strip.empty? }
boards = Array.new(input.length / 5) { Array.new(5) { Array.new(5) } }

input.each_with_index do |value, index|
  boards[index / 5][index % 5] = value.split(' ').map(&:to_i)
end

# numbers = [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1]
# boards = [[[22, 13, 17, 11,  0], [ 8,  2, 23,  4, 24], [21,  9, 14, 16,  7], [ 6, 10,  3, 18,  5], [ 1, 12, 20, 15, 19]],
#           [[ 3, 15,  0,  2, 22], [ 9, 18, 13, 17,  5], [19,  8,  7, 25, 23], [20, 11, 10, 24,  4], [14, 21, 16, 12,  6]],
#           [[14, 21, 17, 24,  4], [10, 16, 15,  9, 19], [18,  8, 23, 26, 20], [22, 11, 13,  6,  5], [ 2,  0, 12,  3,  7]]]

# row_scores = Array.new(boards.length) { Array.new(boards[0].length) { 0 } }
# col_scores = Array.new(boards.length) { Array.new(boards[0].length) { 0 } }

# win = 0
# score = 0
# last_number = -1

# def sum(board, nums)
#   sum = 0
#   board.each { |row| row.each { |el| sum += el unless nums.include? el } }
#   sum
# end

# numbers.each_with_index do |n, iteration|
#   boards.each_with_index do |board, index|
#     bingo = false
#     board.each_with_index do |row, i|
#       row.each_with_index do |el, j|
#         next if n != el

#         row_scores[index][i] += 1
#         col_scores[index][j] += 1
#         bingo = true if row_scores[index][i] == 5 || col_scores[index][j] == 5
#       end
#     end
#     next unless bingo

#     win = index + 1
#     last_number = n
#     score = sum(board, numbers[0..iteration])
#   end
#   break if win != 0
# end

# puts win
# puts score
# puts last_number * score

row_scores = Array.new(boards.length) { Array.new(5) { 0 } }
col_scores = Array.new(boards.length) { Array.new(5) { 0 } }
wins = Array.new(boards.length) { false }

number_of_winners = 0
win = 0
score = 0
last_number = -1

def sum(board, nums)
  sum = 0
  board.each { |row| row.each { |el| sum += el unless nums.include? el } }
  sum
end

numbers.each_with_index do |n, iteration|
  boards.each_with_index do |board, index|
    next if wins[index]

    bingo = false
    board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        next if n != el

        row_scores[index][i] += 1
        col_scores[index][j] += 1
        bingo = true if row_scores[index][i] == 5 || col_scores[index][j] == 5
      end
    end
    next unless bingo

    number_of_winners += 1
    win = index + 1
    last_number = n
    score = sum(board, numbers[0..iteration])
    wins[index] = true
  end
  break if wins.reduce { |sum, num| sum && num }
end

puts wins
puts win
puts score
puts last_number * score
