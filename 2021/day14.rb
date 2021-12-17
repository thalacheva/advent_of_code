# template = "NNCB"
template = "OOVSKSPKPPPNNFFBCNOV"
input = File.readlines('day14.txt', chomp: true)
instructions = {}
input.each do |line|
  key, value = line.split('->').map(&:strip)
  instructions[:"#{key}"] = value
end

def iterate(template, instructions, steps)
  return template if steps.zero?

  result = ''
  template.chars.each_with_index do |char, index|
    result << char
    result << instructions[:"#{char + template[index + 1]}"] if index < template.length - 1
  end

  iterate(result, instructions, steps - 1)
end

# result = iterate(template, instructions, 10)
# freq = result.chars.map { |c| [c, result.count(c)] }.uniq.sort_by { |c| c[1] }
# puts freq.last[1] - freq.first[1]

frequensies = instructions.inject({}) { |h, (k, _)| h[k] = 0; h }
letters = template.chars.uniq.map { |c| [:"#{c}", template.count(c)] }.to_h

template.chars.each_with_index do |char, index|
  break if index > template.length - 2

  frequensies[:"#{char + template[index + 1]}"] += 1
end

40.times do
  frequensies.clone.each do |key, value|
    next if value.zero?

    new_char = instructions[:"#{key}"]
    letters[:"#{new_char}"] = 0 unless letters[:"#{new_char}"]
    letters[:"#{new_char}"] += value
    frequensies[:"#{key}"] -= value
    frequensies[:"#{key[0] + new_char}"] += value
    frequensies[:"#{new_char + key[1]}"] += value
  end
end

result = letters.values.sort
puts result.last - result.first
