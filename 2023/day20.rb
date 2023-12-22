input = File.readlines('day20.txt').map(&:chomp)

Module = Struct.new(:type, :destinations, :state, :received)
Signal = Struct.new(:source, :signal, :name)

def parse(input)
  modules = Hash.new

  conjunctions = Array.new
  input.each do |line|
    source, destination = line.split(' -> ')
    if source === 'broadcaster'
      modules[source] = Module.new('broadcaster', destination.split(', '), nil, nil)
    else
      type = source[0]
      name = source[1..-1]
      if type == '%'
        modules[name] = Module.new(type, destination.split(', '), 'off', nil)
      else
        modules[name] = Module.new(type, destination.split(', '), nil, Hash.new)
        conjunctions << name
      end
    end
  end

  conjunctions.each do |name|
    modules.each do |key, value|
      if value.destinations.include?(name)
        modules[name].received[key] = 'low'
      end
    end
  end

  modules
end

def part1(input)
  modules = parse(input)
  low, high = 0, 0

  1000.times do 
    queue = [Signal.new('button', 'low', 'broadcaster')]

    until queue.empty?
      signal = queue.shift
      # p "#{signal.source} -#{signal.signal} -> #{signal.name}"

      if signal.signal == 'low'
        low += 1
      else
        high += 1
      end

      m = modules[signal.name]
      next unless m

      if m.type == '%'
        if signal.signal == 'low'
          m.state = m.state == 'on' ? 'off' : 'on'
          next_signal = m.state == 'off' ? 'low' : 'high'
          m.destinations.each { |d| queue << Signal.new(signal.name, next_signal, d) }
        end
      elsif m.type == '&'
        m.received[signal.source] = signal.signal
        next_signal = m.received.all? { |k, v| v == 'high' } ? 'low' : 'high'
        m.destinations.each { |d| queue << Signal.new(signal.name, next_signal, d) }
      else
        m.destinations.each { |d| queue << Signal.new(signal.name, signal.signal, d) }
      end
    end
  end

  p "low: #{low}, high: #{high}"
  p "result: #{low * high}"
end

def part2(input)
  modules = parse(input)
  counter = 0
  hash = {
    zv: 0,
    bq: 0,
    qh: 0,
    lt: 0
  }

  while true
    queue = [Signal.new('button', 'low', 'broadcaster')]
    counter += 1
    p "button pressed #{counter} times"

    until queue.empty?
      signal = queue.shift
      # p "#{signal.source} -#{signal.signal} -> #{signal.name}"

      m = modules[signal.name]
      unless m 
        p "last signal: #{signal.signal} to #{signal.name}"
        p hash.values
        if signal.signal == 'low' 
          p "result: #{counter}"
          return
        else
          break
        end

        if hash.values.all? { |v| v > 0 } 
          p "result: #{hash}"
          p hash.values.reduce(1) { |acc, n| acc.lcm(n) }
          break
        end
      end

      if signal.source == 'zv'&& signal.signal == 'high'
        p "zv received high after #{counter} presses"
        hash[:zv] = counter
      elsif signal.source == 'bq' && signal.signal == 'high'
        p "bq received high after #{counter} presses"
        hash[:bq] = counter
      elsif signal.source == 'qh' && signal.signal == 'high'
        p "qh received high after #{counter} presses"
        hash[:qh] = counter
      elsif signal.source == 'lt' && signal.signal == 'high'
        p "lt received high after #{counter} presses"
        hash[:lt] = counter
      end

      if m.type == '%'
        if signal.signal == 'low'
          m.state = m.state == 'on' ? 'off' : 'on'
          next_signal = m.state == 'off' ? 'low' : 'high'
          m.destinations.each { |d| queue << Signal.new(signal.name, next_signal, d) }
        end
      elsif m.type == '&'
        m.received[signal.source] = signal.signal
        next_signal = m.received.all? { |k, v| v == 'high' } ? 'low' : 'high'
        m.destinations.each { |d| queue << Signal.new(signal.name, next_signal, d) }
      else
        m.destinations.each { |d| queue << Signal.new(signal.name, signal.signal, d) }
      end
    end
  end
end

part2 input