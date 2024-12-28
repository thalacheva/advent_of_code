const fs = require('fs');
const codes = fs.readFileSync('day21.txt', 'utf-8').trim().split('\n').map(line => line.split(''));

const k1 = [['7', '8', '9'], ['4', '5', '6'], ['1', '2', '3'], [null, '0', 'A']];
const k2 = [[null, '^', 'A'], ['<', 'v', '>']];

function find(keyboard, code) {
  for (let x = 0; x < keyboard.length; x++) {
    for (let y = 0; y < keyboard[x].length; y++) {
      if (keyboard[x][y] === code) return [x, y];
    }
  }
}

function direction(dx, dy) {
  if (dx === 0 && dy === 1) return '>';
  if (dx === 0 && dy === -1) return '<';
  if (dx === 1 && dy === 0) return 'v';
  if (dx === -1 && dy === 0) return '^';
}

function minify(path) {
  return path.join('').replace(/(<+)/g, '<').replace(/(>+)/g, '>').replace(/(\^+)/g, '^').replace(/(v+)/g, 'v').replace(/(A+)/g, 'A');
}

function dijkstra(keyboard, start, end) {
  const [sx, sy] = start
  const [ex, ey] = end
  const queue = [[sx, sy, 0, []]]
  const visited = Array(keyboard.length).fill().map(() => Array(keyboard[0].length).fill(Infinity))
  visited[sx][sy] = 0
  let paths = []
  let minDist = Infinity

  while (queue.length) {
    const [x, y, dist, path] = queue.shift()

    if (x === ex && y === ey) {
      if (dist < minDist) {
        minDist = dist
        paths = []
      }
      if (dist === minDist) paths.push(path)
      continue
    }

    for (const [dx, dy] of [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
      const nx = x + dx
      const ny = y + dy
      if (nx < 0 || ny < 0 || nx >= keyboard.length || ny >= keyboard[0].length || !keyboard[nx][ny]) continue

      if (dist + 1 <= visited[nx][ny]) {
        visited[nx][ny] = dist + 1
        queue.push([nx, ny, dist + 1, [...path, direction(dx, dy)]])
      }
    }
  }

  paths = paths.map(p => ({original: p, minified: minify(p)}));
  const minPathLength = minLength(paths.map(p => p.minified));
  const bestPaths = paths.filter(p => p.minified.length === minPathLength).map(p => p.original);

  return bestPaths;
}

function mergePaths(paths, parts) {
  if (paths.length === 0) paths = parts.map(p => [...p, 'A']);
  else {
    const newPaths = [];
    for (const path of paths) {
      for (const part of parts) {
        newPaths.push([...path, ...part, 'A']);
      }
    }
    paths = newPaths;
  }

  return paths
}

function minLength(paths) {
  let minPathLength = Infinity;
  for (const path of paths) {
    if (path.length < minPathLength) minPathLength = path.length;
  }

  return minPathLength
}

function minPaths(paths) {
  const minPathLength = minLength(paths);
  const minPaths = paths.filter(path => path.length === minPathLength);
  // if (minPaths.length === 1) return minPaths;

  // let ppPaths = minPaths.filter(path => !path.join('').includes('<A'));
  // if (ppPaths.length === 0) ppPaths = minPaths.filter(path => !path.join('').includes('^>A'));
  // else ppPaths = ppPaths.filter(path => !path.join('').includes('^>A'));

  // if (ppPaths.length > 0) return ppPaths.filter(path => !path.join('').includes('v<A'));

  return minPaths;
}

function forward(paths) {
  const newPaths = [];
  for (const path of paths) {
    let paths2 = [];
    start = [0, 2];
    for (let i = 0; i < path.length; i++) {
      const end = find(k2, path[i]);
      const parts = dijkstra(k2, start, end);
      paths2 = mergePaths(paths2, parts);
      start = end;
    }

    newPaths.push(...paths2);
  }

  return minPaths(newPaths);
}

function print(paths) {
  for (const path of paths) {
    console.log(path.join(''), ' length: ', path.length);
  }
}

function part1() {
  let complexity = 0;

  for (const code of codes) {
    let paths = [];
    let start = [3, 2];
    for (let i = 0; i < code.length; i++) {
      const end = find(k1, code[i]);
      const parts = dijkstra(k1, start, end);
      paths = mergePaths(paths, parts);
      start = end;
    }

    for (let i = 0; i < 2; i++) {
      paths = forward(paths);
    }

    complexity += minLength(paths) * Number(code.join('').match(/\d+/)[0]);
  }

  console.log(complexity);
}

function chooseBest(variants) {
  let bestVariant;
  let minLen = Infinity;

  for (const variant of variants) {
    let results = [variant];
    for (let i = 0; i < 2; i++) {
      results = forward(results);
    }

    const minPathLength = minLength(results);
    if (minPathLength < minLen) {
      minLen = minPathLength;
      bestVariant = variant;
    }
  }

  return bestVariant;
}

function toParts(path) {
  return path.split('A').map(p => p + 'A').slice(0, -1);
}

const map = new Map();

function calcComplexity(path) {
  const partsArr = toParts(path, 1);
  let partsMap = new Map();
  for (const part of partsArr) {
    if (partsMap.has(part)) {
      partsMap.set(part, partsMap.get(part) + 1);
    } else {
      partsMap.set(part, 1);
    }
  }

  for (let i = 0; i < 25; i++) {
    const newParts = new Map();
    partsMap.forEach((count, prt) => {
      let pp;
      if (map.has(prt)) {
        pp = map.get(prt);
      } else {
        const variants = forward([prt]);
        pp = chooseBest(variants).join('');
        map.set(prt, pp);
      }

      const pArr = toParts(pp);
      for (const p of pArr) {
        if (newParts.has(p)) {
          newParts.set(p, newParts.get(p) + count);
        } else {
          newParts.set(p, count);
        }
      }
    });

    partsMap = newParts;
  }

  let len = 0;
  partsMap.forEach((count, p) => len += p.length * count);

  return len;
}

function part2() {
  let complexity = 0;

  for (const code of codes) {
    let paths = [];
    let start = [3, 2];
    for (let i = 0; i < code.length; i++) {
      const end = find(k1, code[i]);
      const parts = dijkstra(k1, start, end);
      paths = mergePaths(paths, parts);
      start = end;
    }

    let minLen = Infinity;
    for (const path of paths) {
      const len = calcComplexity(path.join(''));
      if (len < minLen) minLen = len;
    }

    complexity += minLen * Number(code.join('').match(/\d+/)[0]);
  }

  console.log(complexity);
}

part1();
part2();
