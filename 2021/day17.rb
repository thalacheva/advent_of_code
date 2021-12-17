states = { too_slow: 1, reached: 2, too_fast: 3, too_down: 4 }

def reach(x, y, target_x, target_y, prev_state, states)
  steps = 0
  position = { x: 0, y: 0 }
  velocity = { x: x, y: y }
  max_y = position[:y]
  state = prev_state

  loop do
    steps += 1
    position[:x] += velocity[:x]
    position[:y] += velocity[:y]
    max_y = [position[:y], max_y].max

    if position[:x].between?(target_x[0], target_x[1]) && position[:y].between?(target_y[0], target_y[1])
      puts "In the target after #{steps} with starting velocity #{x}, #{y} and max height of #{max_y}"
      state = states[:reached]
      break
    elsif position[:y] < target_y.min
      state = states[:too_down]
      break
    elsif velocity[:x].zero? && !position[:x].between?(target_x[0], target_x[1])
      state = states[:too_slow] if position[:x] < target_x[0]
      state = states[:too_fast] if position[:x] > target_x[1]
    end

    if velocity[:x] != 0
      velocity[:x] = velocity[:x].positive? ? velocity[:x] - 1 : velocity[:x] + 1
    end
    velocity[:y] -= 1
  end

  { max_y: max_y, state: state }
end

# target_x = [20, 30]
# target_y = [-10, -5]
target_x = [175, 227]
target_y = [-134, -79]
max_y = 0
successes = 0

(1..target_x[1]).each do |x|
  y = target_y[0]
  state = nil
  while y < 500
    result = reach(x, y, target_x, target_y, state, states)

    # break if state == 2 && result[:state] != 2

    state = result[:state]
    # break if state == 1

    max_y = [max_y, result[:max_y]].max if state == 2
    successes += 1 if state == 2
    y += 1
  end
end

puts "the probe reached a maximum y position of #{max_y} and number: #{successes}"
