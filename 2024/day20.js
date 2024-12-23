const fs = require('fs');
const data = fs.readFileSync('day20.txt', 'utf8').trim().split('\n').map(row => row.split(''));

function print(maze) {
  console.log(maze.map(x => x.join('')).join('\n'))
}

const n = data.length
const start = [], end = [];
for (let y = 0; y < n; y++) {
  for (let x = 0; x < n; x++) {
    if (data[y][x] === 'S') start.push(x, y)
    if (data[y][x] === 'E') end.push(x, y)
  }
}

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

function part1(data) {
  const normal = dijkstra(data, start, end)
  let count = 0
  for (let y = 0; y < n; y++) {
    for (let x = 0; x < n; x++) {
      if (data[y][x] === '#') {
        data[y][x] = '.'
        const path = dijkstra(data, start, end)
        if (normal - path >= 100) count++
        data[y][x] = '#'
      }
    }
  }

  console.log(count)
}

function dijkstraExtra(maze, start, end, extra) {
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

    if (x === extra[0][0] && y === extra[0][1]) {
      const extraX = extra[1][0]
      const extraY = extra[1][1]
      const extraDist = dist + Math.abs(extraX - x) + Math.abs(extraY - y)
      if (extraDist < visited[extraY][extraX]) {
        visited[extraY][extraX] = extraDist
        queue.push([extraX, extraY, extraDist])
      }
    }
  }

  return -1
}

function part2(data) {
  const normal = dijkstra(data, start, end)
  let counter = 0
  const map = new Map()
  for (let y = 0; y < n; y++) {
    for (let x = 0; x < n; x++) {
      for (let j = 0; j <= 20; j++) {
        for (let i = 0; i <= 20 - j; i++) {
          if (y + j >= n || x + i >= n || i + j === 0) continue

          const extra = dijkstraExtra(data, start, end, [[x, y], [x + i, y + j]])
          if (normal - extra >= 50) {
            counter++
            map.set(normal - extra, map.get(normal - extra) + 1 || 1)
          }
        }
      }
    }
  }

  console.log(new Map([...map.entries()].sort((a, b) => a[0] - b[0])))
  console.log(counter)
}

part2(data) // 285
