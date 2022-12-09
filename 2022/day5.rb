# crates = [
#   ['Z', 'N'],
#   ['M', 'C', 'D'],
#   ['P']
# ]

# moves = [
#   'move 1 from 2 to 1',
#   'move 3 from 1 to 3',
#   'move 2 from 2 to 1',
#   'move 1 from 1 to 2'
# ]

#         [F] [Q]         [Q]
# [B]     [Q] [V] [D]     [S]
# [S] [P] [T] [R] [M]     [D]
# [J] [V] [W] [M] [F]     [J]     [J]
# [Z] [G] [S] [W] [N] [D] [R]     [T]
# [V] [M] [B] [G] [S] [C] [T] [V] [S]
# [D] [S] [L] [J] [L] [G] [G] [F] [R]
# [G] [Z] [C] [H] [C] [R] [H] [P] [D]
#  1   2   3   4   5   6   7   8   9

crates = [
  %w(G D V Z J S B),
  %w(Z S M G V P),
  %w(C L B S W T Q F),
  %w(H J G W M R V Q),
  %w(C L S N F M D),
  %w(R G C D),
  %w(H G T R J D S Q),
  %w(P F V),
  %w(D R S T J),
 ]

input = File.readlines('day5.txt')

def part1(crates, moves)
  moves.each do |move|
    parts = move.split(' ')
    number = parts[1].to_i
    from = parts[3].to_i
    to = parts[5].to_i

    for i in 1..number do
      crate = crates[from - 1].pop
      crates[to - 1].push crate
    end
  end

  result = ''
  crates.each do |crate|
    result << crate.last
  end

  result
end

def part2(crates, moves)
  moves.each do |move|
    parts = move.split(' ')
    number = parts[1].to_i
    from = parts[3].to_i
    to = parts[5].to_i
    crate = crates[from - 1].pop number
    crates[to - 1] += crate
  end

  result = ''
  crates.each do |crate|
    puts crate.to_s
    result << crate.last
  end

  result
end

# puts part1(crates, moves)
puts part2(crates, input)
