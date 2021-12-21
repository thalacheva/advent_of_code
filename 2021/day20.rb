# enhance_pattern = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"
# data = [
#   "#..#.",
#   "#....",
#   "##..#",
#   "..#..",
#   "..###",
# ]
data = []
enhance_pattern = ''
input = File.readlines('day20.txt', chomp: true)
input.each_with_index do |line, index|
  enhance_pattern = line if index.zero?
  data << line if index > 1
end

def enhance(image, pattern)
  enhanced_image = []
  image.each_with_index do |row, i|
    enhanced_row = ''
    row.chars.each_with_index do |_, j|
      next if i.zero? || i == image.length - 1 || j.zero? || j == row.length - 1

      str = image[i - 1][j - 1, 3] + image[i][j - 1, 3] + image[i + 1][j - 1, 3]
      index = str.gsub('.', '0').gsub('#', '1').to_i(2)
      enhanced_row << pattern[index]
    end
    enhanced_image << enhanced_row
  end

  enhanced_image[1..-2]
end

def prepare(image, char)
  prepared = []
  dots_row = char * (image[0].length + 4)
  2.times { prepared << dots_row }
  image.each do |line|
    prepared << "#{char * 2}#{line}#{char * 2}"
  end
  2.times { prepared << dots_row }

  prepared
end

result = data
infinity_char = '.'
50.times do
  result = enhance(prepare(result, infinity_char), enhance_pattern)
  infinity_char = infinity_char == '.' ? enhance_pattern[0] : enhance_pattern[-1]
end

result.each { |row| puts row }
puts result.join.count('#')
