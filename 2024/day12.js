const fs = require('fs');
const data = fs.readFileSync('day12.txt', 'utf8').trim().split('\n').map(row => row.split(''));

const visited = [...Array(data.length)].map(() => Array(data[0].length).fill(false));
const map = new Map();

function region(x, y, prefix) {
  if (visited[x][y]) return;

  visited[x][y] = true;
  const current = map.get(data[x][y] + prefix) || {area: 0, perimeter: 0};
  map.set(data[x][y] + prefix, {area: current.area + 1, perimeter: current.perimeter + 4});

  if (x < data.length - 1 && data[x][y] === data[x + 1][y]) {
    const c1 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {area: c1.area, perimeter: c1.perimeter - 1});
    region(x + 1, y, prefix);
  }
  if (x > 0 && data[x][y] === data[x - 1][y]) {
    const c2 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {area: c2.area, perimeter: c2.perimeter - 1});
    region(x - 1, y, prefix);
  }
  if (y < data[x].length - 1 && data[x][y] === data[x][y + 1]) {
    const c3 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {area: c3.area, perimeter: c3.perimeter - 1});
    region(x, y + 1, prefix);
  }
  if (y > 0 && data[x][y] === data[x][y - 1]) {
    const c4 = map.get(data[x][y] + prefix);
    map.set(data[x][y] + prefix, {area: c4.area, perimeter: c4.perimeter - 1});
    region(x, y - 1, prefix);
  }
}


for (let i = 0; i < data.length; i++) {
  for (let j = 0; j < data[i].length; j++) {
    if (!visited[i][j]) region(i, j, `${i},${j}`);
  }
}

console.log(map.entries().reduce((acc, val) => acc + val[1].area * val[1].perimeter, 0));
