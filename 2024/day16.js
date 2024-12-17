const fs = require('fs');
const data = fs.readFileSync('day16.txt', 'utf8').trim().split('\n').map(row => row.split(''));

const DIRECTIONS = [
  [0, 1],   // East
  [1, 0],   // South
  [0, -1],  // West
  [-1, 0]   // North
];

class PriorityQueue {
  constructor() {
    this.queue = [];
  }

  enqueue(state, cost, path) {
    this.queue.push({ state, cost, path });
    this.queue.sort((a, b) => a.cost - b.cost);
  }

  dequeue() {
    return this.queue.shift();
  }

  isEmpty() {
    return this.queue.length === 0;
  }
}

function isOnPath(paths, x, y) {
  for (const path of paths)
    for (const [px, py] of path)
      if (px === x && py === y) return true;
}

function print(maze, paths) {
  const n = maze.length;
  let sum = 0;

  for (let i = 0; i < n; i++) {
    let row = '';
    for (let j = 0; j < n; j++) {
      if (isOnPath(paths, i, j)) {
        row += 'O';
        sum++;
      } else row += maze[i][j];
    }
    console.log(row);
  }

  return sum;
}

function dijkstra(maze) {
  const n = maze.length;
  const start = [n - 2, 1];
  const end = [1, n - 2];

  const visited = new Map();
  const pq = new PriorityQueue();
  let paths = [];

  pq.enqueue({ position: start, direction: 0, path: [start] }, 0);

  let minCost = Infinity;

  while (!pq.isEmpty()) {
    const { state, cost } = pq.dequeue();
    const { position, direction, path } = state;
    const [x, y] = position;

    if (x === end[0] && y === end[1]) {
      if (cost < minCost) {
        minCost = cost;
        paths = [];
      }
      if (cost === minCost) paths.push(path);
      continue;
    }

    const key = `${x},${y},${direction}`;
    if (visited.has(key) && visited.get(key) < cost) continue;
    visited.set(key, cost);

    const [dx, dy] = DIRECTIONS[direction];
    const nx = x + dx;
    const ny = y + dy;
    if (nx >= 0 && nx < n && ny >= 0 && ny < n && maze[nx][ny] !== '#') {
      pq.enqueue({ position: [nx, ny], direction, path: [...path, [nx, ny]] }, cost + 1);
    }

    for (const turn of [-1, 1]) {
      const newDirection = (direction + turn + 4) % 4;
      pq.enqueue({ position: [x, y], direction: newDirection, path: [...path] }, cost + 1000);
    }
  }

  return {minCost, paths};
}

const {minCost, paths} = dijkstra(data);
console.log(print(data, paths));
console.log(paths.length);
console.log(minCost);

