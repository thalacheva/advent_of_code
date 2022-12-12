require 'pry'

input = File.readlines('day11.txt')

Monkey = Struct.new(:items, :operation, :value, :test, :positive, :negative, :times)
monkeys = []
i = 1
while i < input.length do
  items = input[i].chomp['  Starting items: '.length..-1].split(', ').map(&:to_i)
  operation = input[i+1].chomp['  Operation: new = old '.length, 1]
  value = input[i+1].chomp['  Operation: new = old '.length + 2..-1]
  value = value.to_i if value != 'old'
  test = input[i+2].chomp['  Test: divisible by '.length..-1].to_i
  positive = input[i+3].chomp['    If true: throw to monkey '.length..-1].to_i
  negative = input[i+4].chomp['    If false: throw to monkey '.length..-1].to_i
  monkey = Monkey.new items, operation, value, test, positive, negative, 0
  monkeys << monkey
  i += 7
end

def part1(monkeys)
  20.times do
    for m in 0..monkeys.length - 1 do
      monkey = monkeys[m]
      while monkey.items.length > 0 do
        item = monkey.items.shift
        if monkey.operation == '*'
          worry = item * (monkey.value == 'old' ? item : monkey.value)
        else
          worry = item + (monkey.value == 'old' ? item : monkey.value)
        end
        worry /= 3
        if worry % monkey.test == 0
          pos_m = monkeys[monkey.positive]
          pos_m.items << worry
        else
          neg_m = monkeys[monkey.negative]
          neg_m.items << worry
        end
        monkey.times += 1
      end
    end
  end

  mb = monkeys.map(&:times).sort.reverse
  p mb
  p mb[0] * mb[1]
end

def part2(monkeys)
  nok = monkeys.map(&:test).reduce(1, :*)
  for r in 1..10000 do
    for m in 0..monkeys.length - 1 do
      monkey = monkeys[m]
      while monkey.items.length > 0 do
        item = monkey.items.shift
        worry = calc_worry(item, monkey)
        if worry % monkey.test == 0
          pos_m = monkeys[monkey.positive]
          pos_m.items << worry % nok
        else
          neg_m = monkeys[monkey.negative]
          neg_m.items << worry % nok
        end
        monkey.times += 1
      end
    end
  end

  mb = monkeys.map(&:times).sort.reverse
  p mb[0] * mb[1]
end

def calc_worry(worry, monkey)
  value = monkey.value == 'old' ? worry : monkey.value
  return worry * value if monkey.operation == '*'

  worry + value
end

part2(monkeys)
