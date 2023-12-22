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

def add_part(parts, part, destination)
  if parts[destination].nil?
    parts[destination] = [part]
  else
    parts[destination] << part
  end
end

def part2(input)
  workflows, _ = parse(input)
  range = [1, 4000]
  parts = { 'in' => [Part.new(range, range, range, range)] }
  
  queue = ['in']

  until queue.empty?
    destination = queue.shift
    next unless workflows[destination]
    # p destination
    # pp parts
    # p '-----------------'

    parts[destination].each do |part|
      left = Part.new(part.x.dup, part.m.dup, part.a.dup, part.s.dup)
      workflows[destination].each do |rule|
        if rule.condition.nil?
          add_part(parts, left, rule.destination)
        else
          category = rule.condition.category
          operation = rule.condition.operation
          value = rule.condition.value
          
          if operation == '>'
            if left[category][0] > value
              add_part(parts, left, rule.destination)
              break
            elsif left[category][1] <= value 
              # nothing
            else
              p1 = Part.new(left.x.dup, left.m.dup, left.a.dup, left.s.dup)
              p1[category] = [value + 1, left[category][1]]
              add_part(parts, p1, rule.destination)
              left[category][1] = value
            end
          elsif operation == '<'
            if left[category][1] < value
              add_part(parts, left, rule.destination)
              break
            elsif left[category][0] >= value
              # nothing
            else
              p1 = Part.new(left.x.dup, left.m.dup, left.a.dup, left.s.dup)
              p1[category] = [left[category][0], value - 1]
              add_part(parts, p1, rule.destination)
              left[category][0] = value
            end
          end
        end

        queue << rule.destination unless queue.include?(rule.destination)
      end
    end
  end
  
  parts
end

accepted = part2(input)['A']
total = 0
accepted.each do |part|
  total += (part.x[1] - part.x[0] + 1) * (part.m[1] - part.m[0] + 1) * 
           (part.a[1] - part.a[0] + 1) * (part.s[1] - part.s[0] + 1)
end

p total
