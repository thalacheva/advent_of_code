player1 = {
  position: 1,
  score: 0
}

player2 = {
  position: 2,
  score: 0
}

def calc_position(old_positon, steps)
  new_position = old_positon + steps
  new_position %= 10
  new_position = 10 if new_position.zero?
  new_position
end

def part1(player1, player2)
  die = 0
  turn = 0
  loop do
    turn += 1
    steps = 3 * die + 6
    die += 3
    die = die % 100 if die > 100
    player = turn.odd? ? player1 : player2
    player[:position] = calc_position(player[:position], steps)
    player[:score] += player[:position]

    return player2[:score] * turn * 3 if player1[:score] >= 1000

    return player1[:score] * turn * 3 if player2[:score] >= 1000
  end
end

$die_map = {
  'die_3': 1,
  'die_4': 3,
  'die_5': 6,
  'die_6': 7,
  'die_7': 6,
  'die_8': 3,
  'die_9': 1
}
def play(p1, p2, turn, wins, number_of_universes)
  for die in 3..9 do
    cur_p1 = p1.dup
    cur_p2 = p2.dup
    player = turn.odd? ? cur_p1 : cur_p2
    player[:position] = calc_position(player[:position], die)
    player[:score] += player[:position]
    if player[:score] >= 21
      wins[turn.odd? ? :player1 : :player2] += number_of_universes * $die_map[:"die_#{die}"]
    else
      play(cur_p1, cur_p2, turn + 1, wins, number_of_universes * $die_map[:"die_#{die}"])
    end
  end
end

# puts part1(player1, player2)
wins = {
  player1: 0,
  player2: 0
}
play(player1, player2, 1, wins, 1)
puts wins
