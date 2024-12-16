const fs = require('fs');
const data = fs.readFileSync('day16.txt', 'utf8').trim().split('\n').map(row => row.split(''));
const n = data.length;

function print(data, path) {
  for (let i = 0; i < n; i++) {
    let row = '';
    for (let j = 0; j < n; j++) {
      if (path.some(({coords: [x, y]}) => x === i && y === j) && data[i][j] !== 'S' && data[i][j] !== 'E') {
        const p = path.find(({coords: [x, y]}) => x === i && y === j);
        switch (p.direction) {
          case 'N':
            row += '^';
            break;
          case 'E':
            row += '>';
            break;
          case 'S':
            row += 'v';
            break;
          case 'W':
            row += '<';
            break;
        }
      } else {
        row += data[i][j];
      }
    }
    console.log(row);
  }
}

function turn(direction) {
  switch (direction) {
    case 'N':
      return {N: 0, E: 1000, S: 2000, W: 1000};
    case 'E':
      return {N: 1000, E: 0, S: 1000, W: 2000};
    case 'S':
      return {N: 2000, E: 1000, S: 0, W: 1000};
    case 'W':
      return {N: 1000, E: 2000, S: 1000, W: 0};
  }
}

function neighbors(data, src, direction) {
  const [x, y] = src;
  const neighbors = [];

  if (x > 0 && data[x - 1][y] !== '#')
    neighbors.push({coords: [x - 1, y], direction: 'N', distance: 1 + turn(direction).N});

  if (x < n - 1 && data[x + 1][y] !== '#')
    neighbors.push({coords: [x + 1, y], direction: 'S', distance: 1 + turn(direction).S});

  if (y > 0 && data[x][y - 1] !== '#')
    neighbors.push({coords: [x, y - 1], direction: 'W', distance: 1 + turn(direction).W});

  if (y < n - 1 && data[x][y + 1] !== '#')
    neighbors.push({coords: [x, y + 1], direction: 'E', distance: 1 + turn(direction).E});

  return neighbors;
}

function dijkstra() {
  const dist = [...Array(n)].map(() => Array(n).fill({weight: Number.MAX_SAFE_INTEGER, path: []}));
  const s = [n - 2, 1];

  const pq = [{coords: s,  direction: 'E'}];
  dist[s[0]][s[1]] = {weight: 0, path: [{coords: s, direction: 'E', distance: 0}]};

  while (pq.length) {
    pq.sort((a, b) => dist[a.coords[0]][a.coords[1]].weight - dist[b.coords[0]][b.coords[1]].weight);

    const {coords, direction} = pq.shift();
    const [x, y] = coords;

    for (const neighbor of neighbors(data, coords, direction)) {
      const [nx, ny] = neighbor.coords;
      const alt = dist[x][y].weight + neighbor.distance;

      if (alt < dist[nx][ny].weight && !dist[x][y].path.includes(neighbor)) {
        dist[nx][ny] = {weight: alt, path: [...dist[x][y].path, neighbor]};
        pq.push(neighbor);
      }
    }
  }

  return dist[1][n - 2].weight;
}

const s = [n - 2, 1];
const e = [1, n - 2];
const visited = [...Array(n)].map(() => Array(n).fill(false));
let minWeight = dijkstra();

// function findPath(s, e, path = []) {
//   const [x, y] = s.coords;
//   visited[x][y] = true;

//   const pathWeight = path.reduce((acc, {distance}) => acc + distance, 0);

//   if (pathWeight > minWeight) return;

//   if (s.coords[0] === e[0] && s.coords[1] === e[1]) {
//     minWeight = Math.min(minWeight, pathWeight)
//     console.log('found', minWeight);
//   } else {
//     for (const neighbor of neighbors(data, s.coords, s.direction)) {
//       const [nx, ny] = neighbor.coords;
//       if (!visited[nx][ny]) findPath(neighbor, e, [...path, neighbor]);
//       visited[nx][ny] = false;
//     }
//   }
// }

// findPath({coords: s, direction: 'E'}, e);
console.log('FINAL', minWeight);
