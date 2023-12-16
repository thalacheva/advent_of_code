steps = File.read('day15.txt').chomp.split(',')

def hash(a)
  current = 0
  a.chars.each do |char|
    current += char.ord
    current *= 17
    current %= 256
  end

  current
end

def part1(steps)
  sum = 0
  steps.each do |step|
    sum += hash(step)
  end

  sum
end

def part2(steps)
  boxes = Array.new(256) { [] }

  steps.each do |step|
    label = step.scan(/[a-z]+/).first
    box = boxes[hash(label)]

    if step.include?('-')
      box.delete_if { |lens| lens[0] == label }
    else
      label, focal = step.split('=')

      found = false
      box.each_with_index do |lens, index|
        if lens[0] == label
          box[index][1] = focal.to_i
          found = true
          break
        end
      end

      box << [label, focal.to_i] unless found
    end
  end

  sum = 0
  boxes.each_with_index do |box, index|
    next if box.empty?

    box.each_with_index do |lens, slot|
      sum += (index + 1) * (slot + 1) * lens[1]
    end
  end

  sum
end

p part2(steps)
