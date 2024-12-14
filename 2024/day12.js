const fs = require('fs');
const data = fs.readFileSync('day12.txt', 'utf8').trim().split('\n').map(row => row.split(''));

const visited = [...Array(data.length)].map(() => Array(data[0].length).fill(false));
const map = new Map();

function region(x, y, prefix) {
  const n = data.length;
  const m = data[x].length;

  if (visited[x][y]) return;

  visited[x][y] = true;
  const current = map.get(data[x][y] + prefix) || {s: 0, p: 0, v: 0};
  let vertexes = 0;
  const d = x === n - 1 || data[x][y] !== data[x + 1][y];
  const u = x === 0 || data[x][y] !== data[x - 1][y];
  const r = y === m - 1 || data[x][y] !== data[x][y + 1];
  const l = y === 0 || data[x][y] !== data[x][y - 1];

  const rd = x < n - 1 && y < m - 1 && data[x][y] !== data[x + 1][y + 1];
  const ld = x < n - 1 && y > 0 && data[x][y] !== data[x + 1][y - 1];
  const ru = x > 0 && y < m - 1 && data[x][y] !== data[x - 1][y + 1];
  const lu = x > 0 && y > 0 && data[x][y] !== data[x - 1][y - 1];

  const nu = x > 0 && data[x][y] === data[x - 1][y];
  const nd = x < n - 1 && data[x][y] === data[x + 1][y];
  const nr = y < m - 1 && data[x][y] === data[x][y + 1];
  const nl = y > 0 && data[x][y] === data[x][y - 1];

  if (l && u) vertexes++;
  if (l && d) vertexes++;
  if (r && u) vertexes++;
  if (r && d) vertexes++;
  if (nl && nd && ld) vertexes++;
  if (nl && nu && lu) vertexes++;
  if (nr && nd && rd) vertexes++;
  if (nr && nu && ru) vertexes++;

  map.set(data[x][y] + prefix, {s: current.s + 1, p: current.p + 4, v: current.v + vertexes});

  if (x < n - 1 && data[x][y] === data[x + 1][y]) {
    const c1 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {...c1, p: c1.p - 1});
    region(x + 1, y, prefix);
  }
  if (x > 0 && data[x][y] === data[x - 1][y]) {
    const c2 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {...c2, p: c2.p - 1});
    region(x - 1, y, prefix);
  }
  if (y < m - 1 && data[x][y] === data[x][y + 1]) {
    const c3 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {...c3, p: c3.p - 1});
    region(x, y + 1, prefix);
  }
  if (y > 0 && data[x][y] === data[x][y - 1]) {
    const c4 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {...c4, p: c4.p - 1});
    region(x, y - 1, prefix);
  }
}

for (let i = 0; i < data.length; i++) {
  for (let j = 0; j < data[i].length; j++) {
    if (!visited[i][j]) region(i, j, `${i},${j}`);
  }
}

console.log(map.entries().reduce((acc, val) => acc + val[1].s * val[1].p, 0));
console.log(map.entries().reduce((acc, val) => acc + val[1].s * val[1].v, 0));
