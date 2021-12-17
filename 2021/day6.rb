# fishes = [3,4,3,1,2]
fishes = [4,3,3,5,4,1,2,1,3,1,1,1,1,1,2,4,1,3,3,1,1,1,1,2,3,1,1,1,4,1,1,2,1,2,2,1,1,1,1,1,5,1,1,2,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,5,1,4,2,1,1,2,1,3,1,1,2,2,1,1,1,1,1,1,1,1,1,1,4,1,3,2,2,3,1,1,1,4,1,1,1,1,5,1,1,1,5,1,1,3,1,1,2,4,1,1,3,2,4,1,1,1,1,1,5,5,1,1,1,1,1,1,4,1,1,1,3,2,1,1,5,1,1,1,1,1,1,1,5,4,1,5,1,3,4,1,1,1,1,2,1,2,1,1,1,2,2,1,2,3,5,1,1,1,1,3,5,1,1,1,2,1,1,4,1,1,5,1,4,1,2,1,3,1,5,1,4,3,1,3,2,1,1,1,2,2,1,1,1,1,4,5,1,1,1,1,1,3,1,3,4,1,1,4,1,1,3,1,3,1,1,4,5,4,3,2,5,1,1,1,1,1,1,2,1,5,2,5,3,1,1,1,1,1,3,1,1,1,1,5,1,2,1,2,1,1,1,1,2,1,1,1,1,1,1,1,3,3,1,1,5,1,3,5,5,1,1,1,2,1,2,1,5,1,1,1,1,2,1,1,1,2,1]

number = fishes.length
newborns = []

class Fish
  attr_accessor :day, :number_of_fishes

  def initialize(day, number_of_fishes)
     @day = day
     @number_of_fishes = number_of_fishes
  end
end

for i in 1..256 do
  new_fishes = 0

  fishes.map! do |fish|
    new_fishes += 1 if fish.zero?
    fish.zero? ? 6 : fish - 1
  end
  newborns.map! do |fish|
    new_fishes += fish.number_of_fishes if fish.day.zero?
    Fish.new(fish.day.zero? ? 6 : fish.day - 1, fish.number_of_fishes)
  end
  number += new_fishes
  newborns.push(Fish.new(8, new_fishes))

  puts "day #{i} fishes #{number}"
end

puts number
