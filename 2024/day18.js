const fs = require('fs');
const data = fs.readFileSync('day18.txt', 'utf-8').trim().split('\n').map(x => x.split(',').map(Number))

const n = 71
const m = 1024

function print(maze) {
  console.log(maze.map(x => x.join('')).join('\n'))
}

const start = [0, 0]
const end = [n - 1, n - 1]

function dijkstra(maze, start, end) {
  const [sx, sy] = start
  const [ex, ey] = end
  const queue = [[sx, sy, 0]]
  const visited = Array(n).fill().map(() => Array(n).fill(Infinity))
  visited[sy][sx] = 0

  while (queue.length) {
    const [x, y, dist] = queue.shift()
    if (x === ex && y === ey) return dist

    for (const [dx, dy] of [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
      const nx = x + dx
      const ny = y + dy
      if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue
      if (maze[ny][nx] === '#') continue
      if (dist + 1 < visited[ny][nx]) {
        visited[ny][nx] = dist + 1
        queue.push([nx, ny, dist + 1])
      }
    }
  }

  return -1
}

function part1() {
  const maze = Array(n).fill().map(() => Array(n).fill('.'))
  for (let i = 0; i < m; i++) {
    const [x, y] = data[i]
    maze[y][x] = '#'
  }

  return {maze, path: dijkstra(maze, start, end)}
}

function part2() {
  let {maze, path} = part1()
  let i = m

  while (path !== -1 && i < data.length) {
    const [x, y] = data[i]
    maze[y][x] = '#'
    path = dijkstra(maze, start, end)
    i++
  }

  return i - 1
}

console.log(data[part2()].join(','))
