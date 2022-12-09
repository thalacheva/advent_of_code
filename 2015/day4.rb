require 'digest'

test1 = 'abcdef'
test2 = 'pqrstuv'
test3 = 'ckczppom'

def md5(input)
  i = 1
  result = Digest::MD5.hexdigest input
  until result.start_with?('000000') do
    i += 1
    result = Digest::MD5.hexdigest "#{input}#{i}"
  end

  i
end

puts md5(test1)
puts md5(test2)
puts md5(test3)
