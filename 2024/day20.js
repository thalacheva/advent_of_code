const fs = require('fs');
const data = fs.readFileSync('day20.txt', 'utf8').trim().split('\n').map(row => row.split(''));

function print(maze) {
  console.log(maze.map(x => x.join('')).join('\n'))
}

const n = data.length
const start = [], end = [];
for (let x = 0; x < n; x++) {
  for (let y = 0; y < n; y++) {
    if (data[x][y] === 'S') start.push(x, y)
    if (data[x][y] === 'E') end.push(x, y)
  }
}

function dijkstra(maze, start, end) {
  const [sx, sy] = start
  const [ex, ey] = end
  const queue = [[sx, sy, 0]]
  const visited = Array(n).fill().map(() => Array(n).fill(Infinity))
  visited[sx][sy] = 0

  while (queue.length) {
    const [x, y, dist] = queue.shift()
    if (x === ex && y === ey) return dist

    for (const [dx, dy] of [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
      const nx = x + dx
      const ny = y + dy
      if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue
      if (maze[nx][ny] === '#') continue
      if (dist + 1 < visited[nx][ny]) {
        visited[nx][ny] = dist + 1
        queue.push([nx, ny, dist + 1])
      }
    }
  }

  return -1
}

function part1(data) {
  const normal = dijkstra(data, start, end)
  let count = 0
  for (let x = 0; x < n; x++) {
    for (let y = 0; y < n; y++) {
      if (data[x][y] === '#') {
        data[x][y] = '.'
        const path = dijkstra(data, start, end)
        if (normal - path >= 100) count++
        data[x][y] = '#'
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
  visited[sx][sy] = 0

  while (queue.length) {
    const [x, y, dist] = queue.shift()
    if (x === ex && y === ey) return dist

    for (const [dx, dy] of [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
      const nx = x + dx
      const ny = y + dy
      if (nx < 0 || ny < 0 || nx >= n || ny >= n) continue

      if (maze[nx][ny] !== '#') {
        if (dist + 1 < visited[nx][ny]) {
          visited[nx][ny] = dist + 1
          queue.push([nx, ny, dist + 1])
        }
      }
    }

    if (x === extra[0][0] && y === extra[0][1]) {
      const extraX = extra[1][0]
      const extraY = extra[1][1]
      const extraDist = dist + Math.abs(extraX - x) + Math.abs(extraY - y)

      if (extraDist < visited[extraX][extraY]) {
        visited[extraX][extraY] = extraDist
        queue.push([extraX, extraY, extraDist])
      }
    }
  }

  return -1
}

function part2(data) {
  const normal = dijkstra(data, start, end)
  let counter = 0
  // const map = new Map()

  for (let x = 0; x < n; x++) {
    for (let y = 0; y < n; y++) {
      if (data[x][y] !== '#') {
        for (let i = -20; i <= 20; i++) {
          for (let j = -20; j <= 20; j++) {
            if (x + i < 0 || y + j < 0 || x + i >= n || y + j >= n) continue

            const dist = Math.abs(i) + Math.abs(j)
            if (dist > 0 && dist <= 20 && data[x + i][y + j] !== '#') {
              const extra = dijkstraExtra(data, start, end, [[x, y], [x + i, y + j]])
              if (normal - extra >= 100) {
                counter++
                console.log(x, y, x + i, y + j, 'saved: ', normal - extra, 'by now: ', counter)
                // map.set(normal - extra, map.get(normal - extra) + 1 || 1)
              }
            }
          }
        }
      }
    }
  }

  // console.log(new Map([...map.entries()].sort((a, b) => a[0] - b[0])))
  console.log(counter)
}

part2(data) // 285
