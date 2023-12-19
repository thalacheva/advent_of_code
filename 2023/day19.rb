input = File.readlines('day19.txt').map(&:chomp)

Part = Struct.new(:x, :m, :a, :s)
Rule = Struct.new(:condition, :destination)
Condition = Struct.new(:category, :operation, :value)

def parse(input)
  instructions = Hash.new
  parts = []

  input.each do |line|
    next if line.empty?

    if line.start_with?('{')
      parts << Part.new(*line.scan(/\d+/).map(&:to_i))
    else
      id, inst = line.split('{')
      rules = inst[0..-2].split(',')
      instructions[id] = rules.map do |rule|
        rule_parts = rule.split(':')
        if rule_parts.size == 1
          Rule.new(nil, rule_parts[0])
        else
          condition, destination = rule_parts
          Rule.new(Condition.new(condition[0], condition[1], condition[2..-1].to_i), destination)
        end
      end
    end
  end

  [instructions, parts]
end

def part1(input)
  workflows, parts = parse(input)
  accepted = []
  rejected = []

  parts.each do |part|
    destination = 'in'

    until ['A', 'R'].include?(destination)
      workflows[destination].each do |rule|
        if rule.condition.nil?
          destination = rule.destination
          break
        else
          category = part[rule.condition.category]
          operation = rule.condition.operation
          value = rule.condition.value
          if operation == '>' && category > value
            destination = rule.destination
            break
          elsif operation == '<' && category < value
            destination = rule.destination
            break
          end
        end
      end
    end

    accepted << part if destination == 'A'
    rejected << part if destination == 'R'
  end

  p accepted.sum(&:x) + accepted.sum(&:m) + accepted.sum(&:a) + accepted.sum(&:s)
end

def workflow(x, m, a, s, current)

end

def part2(input)
  workflows, _ = parse(input)
  x = [1, 4000]
  m = [1, 4000]
  a = [1, 4000]
  s = [1, 4000]

  destination = 'in'

  until ['A', 'R'].include?(destination)
    workflows[destination].each do |rule|
      if rule.condition.nil?
        destination = rule.destination
        break
      else
        category = rule.condition.category
        operation = rule.condition.operation
        value = rule.condition.value
        if operation == '>' && category > value
          destination = rule.destination
          break
        elsif operation == '<' && category < value
          destination = rule.destination
          break
        end
      end
    end
  end
end

part2 input
