numbers = File.readlines('day25.txt').map(&:chomp)

def to_decimal(snafu)
  decimal = 0
  snafu.reverse.chars.each_with_index do |d, i|
    digit = d == '=' ? -2 : d == '-' ? -1 : d.to_i
    decimal += digit*5**i
  end

  decimal
end

def to_snafu(number)
  snafu = []

  while number > 0 do
    d = number % 5
    number /= 5
    snafu << d
  end

  snafu.each_with_index do |d, i|
    next if d < 3

    j = i
    while snafu[j] >= 3 do
      snafu[j] -= 5
      j += 1
      if j < snafu.length
        snafu[j] += 1
      else
        snafu << 1
      end
    end
  end

  snafu.reverse.map { |d| d == -2 ? '=' : d == -1 ? '-' : d }.join('')
end

sum = numbers.map { |number| to_decimal(number) }.sum
p to_snafu(sum)
