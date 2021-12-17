# input = ["[({(<(())[]>[[{[]{<()<>>",
#         "[(()[<>])]({[<{<<[]>>(",
#         "{([(<{}[<>[]}>{[]{[(<()>",
#         "(((({<>}<{<{<>}{[]{[]{}",
#         "[[<[([]))<([[{}[[()]]]",
#         "[{[{({}]{}}([{[{{{}}([]",
#         "{<[[]]>}<{[{[{[]{()[[[]",
#         "[<(<(<(<{}))><([]([]()",
#         "<{([([[(<>()){}]>(<<{{",
#         "<{([{{}}[<[[[<>{}]]]>[]]"]

input = File.readlines('day10.txt', chomp: true)

def part1(input)
  mapping = { ')': '(', ']': '[', '}': '{', '>': '<' }
  points = { ')': 3, ']': 57, '}': 1197, '>': 25137 }
  score = 0
  input.each do |line|
    stack = []
    line.chars.each do |char|
      if ['(', '[', '{', '<'].include? char
        stack << char
      elsif !stack.empty? && stack.last == mapping[:"#{char}"]
        stack.pop
      else
        score += points[:"#{char}"]
        break
      end
    end
  end

  puts score
end

def part2(input)
  mapping = { ')': '(', ']': '[', '}': '{', '>': '<' }
  points = { '(': 1, '[': 2, '{': 3, '<': 4 }
  scores = []

  input.each do |line|
    stack = []
    line_corrupted = false
    line.chars.each do |char|
      if ['(', '[', '{', '<'].include? char
        stack << char
      elsif !stack.empty? && stack.last == mapping[:"#{char}"]
        stack.pop
      else
        line_corrupted = true
        break
      end
    end

    next if line_corrupted || stack.empty?

    score = 0
    score = score * 5 + points[:"#{stack.pop}"] until stack.empty?
    scores.push(score)
  end

  scores.sort!
  puts scores[scores.length / 2]
end

part1(input)
part2(input)
