lines = File.readlines('day21.txt')
monkeys = []
Monkey = Struct.new(:name, :value, :left, :right, :operation)

lines.each do |line|
  name, rest = line.chomp.split(': ')
  monkeys << (rest.to_i.to_s == rest ? Monkey.new(name, rest.to_i, nil) : Monkey.new(name, nil, rest[0..3], rest[-4..-1], rest[5]))
end

def calc(monkeys, monkey_name)
  monkey = monkeys.find { |m| m.name == monkey_name }
  return monkey.value unless monkey.value.nil?

  left = calc(monkeys, monkey.left)
  right = calc(monkeys, monkey.right)
  case monkey.operation
  when '+'
    return left + right
  when '-'
    return left - right
  when '*'
    return left * right
  when '/'
    return left / right
  end
end

# p calc(monkeys, 'root')

def calc2(monkeys, monkey_name)
  monkey = monkeys.find { |m| m.left == monkey_name }
  if monkey
    return calc(monkeys, monkey.right) if monkey.name == 'root'

    case monkey.operation
    when '+'
      return calc2(monkeys, monkey.name) - calc(monkeys, monkey.right)
    when '-'
      return calc2(monkeys, monkey.name) + calc(monkeys, monkey.right)
    when '*'
      return calc2(monkeys, monkey.name) / calc(monkeys, monkey.right)
    when '/'
      return calc2(monkeys, monkey.name) * calc(monkeys, monkey.right)
    end
  else
    monkey = monkeys.find { |m| m.right == monkey_name }
    return calc(monkeys, monkey.left) if monkey.name == 'root'

    case monkey.operation
    when '+'
      return calc2(monkeys, monkey.name) - calc(monkeys, monkey.left)
    when '-'
      return calc(monkeys, monkey.left) - calc2(monkeys, monkey.name)
    when '*'
      return calc2(monkeys, monkey.name) / calc(monkeys, monkey.left)
    when '/'
      return calc(monkeys, monkey.left) / calc2(monkeys, monkey.name)
    end
  end
end

p calc2(monkeys, 'humn')

