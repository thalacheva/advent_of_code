class AluException < StandardError
  def initialize(msg = 'This is an ALU exception')
    @exception_type = 'ALU'
    super(msg)
  end
end

def alu(instruction, result, input = nil)
  operation, a, b = instruction.split
  b = result[:"#{b}"] || b.to_i

  case operation
  when 'inp'
    result[:"#{a}"] = input
  when 'add'
    result[:"#{a}"] += b
  when 'mul'
    result[:"#{a}"] *= b
  when 'div'
    raise AluException.new 'Division by zero is not allowed' if b.zero?

    result[:"#{a}"] /= b
  when 'mod'
    raise AluException.new 'Mod is not allowed for negative values' if result[:"#{a}"].negative? || b <= 0

    result[:"#{a}"] %= b
  when 'eql'
    result[:"#{a}"] = result[:"#{a}"] == b ? 1 : 0
  end
end

def monad(digits)
  result = { w: 0, x: 0, y: 0, z: 0 }
  instructions = File.readlines('day24.txt', chomp: true)
  instructions.each do |instruction|
    alu(instruction, result, instruction.start_with?('inp') ? digits.shift : nil)
  end

  result
end

def find_model_number
  # number = ('9' * 14).to_i
  number = 99999966294164

  while number >= ('1' * 14).to_i
    str = number.to_s
    if str.end_with?('1')
      i = str.length - 1
      i -= 1 while str[i] == '1'
      number -= str[i + 1..-1].to_i + 1
    else
      number -= 1
    end
    puts number
    begin
      result = monad(number.to_s.chars.map(&:to_i))
      return number if result[:z].zero?
    rescue AluException => e
      puts e.message
      next
    end
  end
end

puts find_model_number
