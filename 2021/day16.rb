input = "A20D6CE8F00033925A95338B6549C0149E3398DE75817200992531E25F005A18C8C8C0001849FDD43629C293004B001059363936796973BF3699CFF4C6C0068C9D72A1231C339802519F001029C2B9C29700B2573962930298B6B524893ABCCEC2BCD681CC010D005E104EFC7246F5EE7328C22C8400424C2538039239F720E3339940263A98029600A80021B1FE34C69100760B41C86D290A8E180256009C9639896A66533E459148200D5AC0149D4E9AACEF0F66B42696194031F000BCE7002D80A8D60277DC00B20227C807E8001CE0C00A7002DC00F300208044E000E69C00B000974C00C1003DC0089B90C1006F5E009CFC87E7E43F3FBADE77BE14C8032C9350D005662754F9BDFA32D881004B12B1964D7000B689B03254564414C016B004A6D3A6BD0DC61E2C95C6E798EA8A4600B5006EC0008542D8690B80010D89F1461B4F535296B6B305A7A4264029580021D1122146900043A0EC7884200085C598CF064C0129CFD8868024592FEE9D7692FEE9D735009E6BBECE0826842730CD250EEA49AA00C4F4B9C9D36D925195A52C4C362EB8043359AE221733DB4B14D9DCE6636ECE48132E040182D802F30AF22F131087EDD9A20804D27BEFF3FD16C8F53A5B599F4866A78D7898C0139418D00424EBB459915200C0BC01098B527C99F4EB54CF0450014A95863BDD3508038600F44C8B90A0801098F91463D1803D07634433200AB68015299EBF4CF5F27F05C600DCEBCCE3A48BC1008B1801AA0803F0CA1AC6200043A2C4558A710E364CC2D14920041E7C9A7040402E987492DE5327CF66A6A93F8CFB4BE60096006E20008543A8330780010E8931C20DCF4BFF13000A424711C4FB32999EE33351500A66E8492F185AB32091F1841C91BE2FDC53C4E80120C8C67EA7734D2448891804B2819245334372CBB0F080480E00D4C0010E82F102360803B1FA2146D963C300BA696A694A501E589A6C80"

def to_binary(hex_str)
  hex_map = {
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'A': '1010',
    'B': '1011',
    'C': '1100',
    'D': '1101',
    'E': '1110',
    'F': '1111'
  }

  bin_str = ''
  hex_str.chars.each do |c|
    bin_str << hex_map[:"#{c}"]
  end

  bin_str
end

# def parse(bin, start_index)
#   i = start_index
#   sum = bin[i, 3].to_i(2)
#   i += 3
#   type = bin[i, 3].to_i(2)
#   i += 3

#   if type == 4
#     while bin[i] != '0'
#       i += 5
#     end
#     i += 5
#     puts "literal, sum is #{sum}, bit is #{i}"
#     { sum: sum, index: i }
#   elsif bin[i] == '0'
#     i += 1
#     total_length = bin[i, 15].to_i(2)
#     i += 15
#     puts "total length is #{total_length}"
#     last_index = i + total_length

#     while i < last_index
#       p = parse(bin, i)
#       puts "result from parse #{p}"
#       i = p[:index]
#       sum += p[:sum]
#     end
#     { sum: sum, index: i }
#   else
#     i += 1
#     number_of_packets = bin[i, 11].to_i(2)
#     puts "number of packets is #{number_of_packets}"
#     n = number_of_packets
#     i += 11
#     while n > 0
#       p = parse(bin, i)
#       i = p[:index]
#       sum += p[:sum]
#       n -= 1
#     end
#     { sum: sum, index: i }
#   end
# end

# puts parse(to_binary(input), 0)[:sum]

def calculate(type, operands)
  puts "type #{type}, operands #{operands}"
  case type
  when 0
    operands.sum
  when 1
    operands.inject(:*)
  when 2
    operands.min
  when 3
    operands.max
  when 5
    operands[0] > operands[1] ? 1 : 0
  when 6
    operands[0] < operands[1] ? 1 : 0
  when 7
    operands[0] == operands[1] ? 1 : 0
  end
end

def parse(bin, start_index)
  i = start_index
  i += 3
  type = bin[i, 3].to_i(2)
  i += 3

  if type == 4
    bin_number = ''
    loop do
      bin_number << bin[i + 1, 4]
      break if bin[i] == '0'

      i += 5
    end
    i += 5
    { result: bin_number.to_i(2), index: i }
  elsif bin[i] == '0'
    i += 1
    total_length = bin[i, 15].to_i(2)
    i += 15
    last_index = i + total_length
    operands = []
    while i < last_index
      p = parse(bin, i)
      i = p[:index]
      operands << p[:result]
    end
    { result: calculate(type, operands), index: i }
  else
    i += 1
    number_of_packets = bin[i, 11].to_i(2)
    n = number_of_packets
    i += 11
    operands = []
    while n > 0
      p = parse(bin, i)
      i = p[:index]
      operands << p[:result]
      n -= 1
    end
    { result: calculate(type, operands), index: i }
  end
end

puts parse(to_binary(input), 0)[:result]

__END__
Part 1 examples

D2FE28 - 6
38006F45291200 - 9
EE00D40C823060 - 14
8A004A801A8002F478 - 16
620080001611562C8802118E34 - 12
C0015000016115A2E0802F182340 - 23
A0016C880162017C3686B18A3D4780 - 31

Part 2 examples

C200B40A82 finds the sum of 1 and 2, resulting in the value 3.
04005AC33890 finds the product of 6 and 9, resulting in the value 54.
880086C3E88112 finds the minimum of 7, 8, and 9, resulting in the value 7.
CE00C43D881120 finds the maximum of 7, 8, and 9, resulting in the value 9.
D8005AC2A8F0 produces 1, because 5 is less than 15.
F600BC2D8F produces 0, because 5 is not greater than 15.
9C005AC2F8F0 produces 0, because 5 is not equal to 15.
9C0141080250320F1802104A08 produces 1, because 1 + 3 = 2 * 2.
