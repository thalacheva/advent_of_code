cards = File.readlines('day4.txt').map(&:chomp)

def task1(cards)
  points = 0

  cards.each do |card|
    a, b = card.split(':').last.split('|').map(&:strip)
    winning = a.split(' ').map(&:to_i)
    having = b.split(' ').map(&:to_i)

    matching = (winning & having).length

    points += 2**(matching - 1) if matching > 0
  end

  points
end

def task2(cards)
  copies = Array.new(cards.length) { 1 }

  cards.each_with_index do |card, i|
    a, b = card.split(':').last.split('|').map(&:strip)
    winning = a.split(' ').map(&:to_i)
    having = b.split(' ').map(&:to_i)

    matching = (winning & having).length

    for j in i+1..i+matching do
      copies[j] += 1 * copies[i]
    end
  end

  copies.sum
end

# p task1(cards)
p task2(cards)
