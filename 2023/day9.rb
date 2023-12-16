# --- Day 9: Mirage Maintenance ---
sequences = File.readlines('day9.txt').map { |s| s.split(' ').map(&:to_i) }

def predict(sequence)
  histories = [sequence]
  until histories.last.all?(&:zero?)
    histories << histories.last.each_cons(2).map{ |a, b| b - a }
  end

  predict = histories.last.last
  histories.reverse_each do |history|
    predict = history.last + predict
  end

  predict
end

def predict_back(sequence)
  histories = [sequence]
  until histories.last.all?(&:zero?)
    histories << histories.last.each_cons(2).map{ |a, b| b - a }
  end

  predict = histories.last.first
  histories.reverse_each do |history|
    predict = history.first - predict
  end

  predict
end

def task1(sequences)
  sequences.map { |sequence| predict(sequence) }.sum
end

def task2(sequences)
  sequences.map { |sequence| predict_back(sequence) }.sum
end

p task2(sequences)
