# input = File.readlines('day8.txt')
# ones = 0
# fours = 0
# sevens = 0
# eigths = 0
# input.each do |line|
#   output = line.split('|')[1].chomp.split(' ')
#   ones += output.select { |element| element.length == 2 }.length
#   fours += output.select { |element| element.length == 4 }.length
#   sevens += output.select { |element| element.length == 3 }.length
#   eigths += output.select { |element| element.length == 7 }.length
# end

# puts ones + fours + sevens + eigths

def find_mapping(input)
  digits = input.chomp.split(' ')
  frequencies = input.chars
                     .reject { |x| x == ' ' }
                     .group_by { |x| x }
                     .map { |k, v| [k, v.length] }
                     .to_h
  one = digits.detect { |d| d.length == 2 }.chars
  seven = digits.detect { |d| d.length == 3 }.chars
  four = digits.detect { |d| d.length == 4 }.chars
  hash = {
    a: (seven - one)[0],
    b: frequencies.key(6),
    e: frequencies.key(4),
    f: frequencies.key(9)
  }
  hash[:c] = (one - [hash[:f]])[0]
  hash[:d] = (four - [hash[:b], hash[:c], hash[:f]])[0]
  hash[:g] = (frequencies.select { |_, v| v == 7 }.keys - [hash[:d]])[0]

  hash
end

def parse(line)
  template = %w[abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg]
  input, output = line.split('|')
  hash = find_mapping(input)

  number = 0
  output.chomp.split(' ').each_with_index do |d, i|
    digit = template.find_index(d.chars.sort.map { |x| hash.key(x) }.sort.join)
    number += digit * 10**(3 - i)
  end

  number
end

# line = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
# puts parse(line)
input = File.readlines('day8.txt')
sum = 0
input.each do |line|
  sum += parse(line)
end

puts sum
