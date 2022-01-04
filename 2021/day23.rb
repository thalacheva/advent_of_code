rooms = [{ type: 'A', entrance: 2, amphipods: ['C', 'D', 'D', 'B'] },
         { type: 'B', entrance: 4, amphipods: ['A', 'B', 'C', 'B'] },
         { type: 'C', entrance: 6, amphipods: ['A', 'A', 'B', 'D'] },
         { type: 'D', entrance: 8, amphipods: ['C', 'C', 'A', 'D'] }]
# rooms = [{ type: 'A', entrance: 2, amphipods: ['A', 'D', 'D', 'B'] },
#          { type: 'B', entrance: 4, amphipods: ['D', 'B', 'C', 'C'] },
#          { type: 'C', entrance: 6, amphipods: ['C', 'A', 'B', 'B'] },
#          { type: 'D', entrance: 8, amphipods: ['A', 'C', 'A', 'D'] }]
# rooms = [{ type: 'A', entrance: 2, amphipods: ['C', 'B'] },
#          { type: 'B', entrance: 4, amphipods: ['A', 'B'] },
#          { type: 'C', entrance: 6, amphipods: ['A', 'D'] },
#          { type: 'D', entrance: 8, amphipods: ['C', 'D'] }]
# rooms = [{ type: 'A', entrance: 2, amphipods: ['A', 'B'] },
#          { type: 'B', entrance: 4, amphipods: ['D', 'C'] },
#          { type: 'C', entrance: 6, amphipods: ['C', 'B'] },
#          { type: 'D', entrance: 8, amphipods: ['A', 'D'] }]

hallway = Array.new(11) { '.' }
ENERGY = {
  A: 1,
  B: 10,
  C: 100,
  D: 1000
}
ROOM_SPACE = 4

class State
  include Comparable

  attr_accessor :rooms, :hallway, :cost

  def initialize(rooms, hallway, cost)
    @rooms, @hallway, @cost = rooms, hallway, cost
  end

  def <=>(other)
    @cost <=> other.cost
  end
end

class PriorityQueue
  attr_accessor :elements

  def initialize(initial_state)
    @elements = [initial_state]
  end

  def bubble_up(left, right, element)
    if left >= right - 1
      @elements.insert(right, element)
      return
    end

    if element > @elements.first
      @elements.insert(0, element)
      return
    end

    middle = (left + right) / 2

    if @elements[middle] == element
      @elements.insert(middle, element)
    elsif @elements[middle] < element
      bubble_up(left, middle, element)
    else
      bubble_up(middle, right, element)
    end
  end

  def <<(element)
    bubble_up(0, @elements.size - 1, element)
  end

  def pop
    @elements.pop
  end

  def empty?
    @elements.empty?
  end
end

def room_full?(room)
  room[:amphipods].length == ROOM_SPACE && room[:amphipods].uniq == [room[:type]]
end

def room_ready?(room)
  room[:amphipods].empty? || room[:amphipods].uniq == [room[:type]]
end

def hallway_empty?(hallway)
  hallway.uniq == ['.']
end

def free_hallway_positions(hallway, room)
  i = room[:entrance]
  i -= 1 while i >= 0 && hallway[i] == '.'
  j = room[:entrance]
  j += 1 while j < hallway.length && hallway[j] == '.'

  [*(i + 1)..(j - 1)] - [2, 4, 6, 8]
end

def path_free?(hallway, room, index)
  hallway_empty?(hallway[[room[:entrance], index].min..[room[:entrance], index].max])
end

def pay_cost(room, index, amphipod)
  ((room[:entrance] - index).abs + ROOM_SPACE - room[:amphipods].length) * ENERGY[:"#{amphipod}"]
end

def move_to_room(rooms, hallway)
  cost = 0
  hallway.each_with_index do |amphipod, index|
    next if amphipod == '.'

    room_index = rooms.index { |r| r[:type] == amphipod }
    room = rooms[room_index]
    pos = room[:entrance] < index ? index - 1 : index + 1
    next unless room_ready?(room) && path_free?(hallway, room, pos)

    cost += pay_cost(room, index, amphipod)
    rooms[room_index][:amphipods].push(amphipod)
    hallway[index] = '.'
  end

  cost
end

def move_to_hallway(rooms, room_index, hallway, index)
  room = rooms[room_index]
  pos = room[:entrance] < index ? index + 1 : index - 1
  cost = pay_cost(room, pos, room[:amphipods].last)
  hallway[index] = rooms[room_index][:amphipods].pop

  cost
end

def finished?(rooms, hallway)
  (rooms.reduce(true) { |acc, room| acc && room_full?(room) }) && hallway_empty?(hallway)
end

def dup_room(room)
  { type: room[:type], entrance: room[:entrance], amphipods: room[:amphipods].map(&:dup) }
end

def dup_rooms(rooms)
  rooms.map { |room| dup_room(room) }
end

def move(rooms, hallway)
  pq = PriorityQueue.new(State.new(rooms, hallway, 0))

  until pq.empty?
    state = pq.pop
    return state.cost if finished?(state.rooms, state.hallway)

    state.rooms.each_with_index do |r, i|
      next if room_full?(r) || room_ready?(r)

      free_hallway_positions(state.hallway, r).each do |j|
        next unless path_free?(state.hallway, r, j)

        dup_rooms = dup_rooms(state.rooms)
        dup_hallway = state.hallway.dup
        cost = state.cost + move_to_hallway(dup_rooms, i, dup_hallway, j)
        move_to_room_cost = move_to_room(dup_rooms, dup_hallway)
        while move_to_room_cost.positive?
          cost += move_to_room_cost
          move_to_room_cost = move_to_room(dup_rooms, dup_hallway)
        end

        pq << State.new(dup_rooms, dup_hallway, cost)
      end
    end
  end
end

puts move(rooms, hallway)
