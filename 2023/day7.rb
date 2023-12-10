lines = File.readlines('day7.txt').map(&:chomp)

def find_type(hand)
  numbers = hand.chars.group_by { |char| char }.map { |k,v| v.size }.sort.reverse

  case numbers
  when [5]
    # :royal_flush
    7
  when [4, 1]
    # :four_of_a_kind
    6
  when [3, 2]
    # :full_house
    5
  when [3, 1, 1]
    # :three_of_a_kind
    4
  when [2, 2, 1]
    # :two_pairs
    3
  when [2, 1, 1, 1]
    # :one_pair
    2
  else
    # :high_card
    1
  end
end

def find_type2(hand)
  numbers = hand.chars.filter {|char| char != 'J'}.group_by { |char| char }.map { |k,v| v.size }.sort.reverse
  jokers = hand.chars.count { |char| char == 'J' }

  numbers = [0] if numbers === []
  numbers[0] += jokers

  case numbers
  when [5]
    7
  when [4, 1]
    6
  when [3, 2]
    5
  when [3, 1, 1]
    4
  when [2, 2, 1]
    3
  when [2, 1, 1, 1]
    2
  else
    1
  end
end

def map_card(card)
  case card
  when 'T'
    10
  when 'J'
    11
  when 'Q'
    12
  when 'K'
    13
  when 'A'
    14
  else
    card.to_i
  end
end

def map_card2(card)
  case card
  when 'T'
    10
  when 'J'
    1
  when 'Q'
    12
  when 'K'
    13
  when 'A'
    14
  else
    card.to_i
  end
end

class Hand
  include Comparable

  attr :hand, :bid

  def initialize(hand, bid)
    @hand = hand
    @bid = bid
  end

  def <=>(other)
    left_type = find_type2(@hand)
    right_type = find_type2(other.hand)
    return left_type <=> right_type if left_type != right_type

    for i in 0..4 do
      next if @hand[i] == other.hand[i]

      return map_card2(@hand[i]) <=> map_card2(other.hand[i])
    end
  end
end

def play(lines)
  cards = lines.map do |line|
    hand, bid = line.split(' ')

    Hand.new(hand, bid.to_i)
  end.sort

  cards.each_with_index.reduce(0) { |acc, (card, index)| acc += card.bid * (index + 1) }
end

p play(lines)
