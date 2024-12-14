const fs = require('fs');
const regex = /(-?\d+)/g;
const robots = fs.readFileSync('day14.txt', 'utf8').trim().split('\n').map(row => {
  const [x, y, v, w] = row.match(regex).map(Number);
  return {p: {x, y}, v: {x: v, y: w}};
});

// const m = 11, n = 7;
const m = 101, n = 103;

function plot(robots) {
  const grid = Array.from({length: n}, () => Array(m).fill('.'));
  for (const {p} of robots) {
    grid[p.y][p.x] = grid[p.y][p.x] === '.' ? 1 : grid[p.y][p.x] + 1;
  }

  return grid.map(row => row.join('')).join('\n');
}

function move(robots) {
  for (const {p, v} of robots) {
    p.x += v.x;
    p.y += v.y;
    if (p.x < 0) p.x = m + p.x;
    if (p.y < 0) p.y = n + p.y;
    if (p.x >= m) p.x -= m;
    if (p.y >= n) p.y -= n;
  }

  return robots;
}

function part1() {
  for (let i = 0; i < 100; i++) {
    move(robots);
  }

  let q1 = 0, q2 = 0, q3 = 0, q4 = 0;
  const mx = (m - 1) / 2, my = (n - 1) / 2;
  for (const {p} of robots) {
    if (p.x < mx && p.y < my) q1++;
    else if (p.x > mx && p.y < my) q2++;
    else if (p.x < mx && p.y > my) q3++;
    else if (p.x > mx && p.y > my) q4++;
  }

  console.log(q1, q2, q3, q4);
  console.log(q1 * q2 * q3 * q4);
}

part1();

function part2() {
  const plots = [plot(robots)];
  let i = 0;
  while (true) {

    move(robots);
    i++;

    const p = plot(robots);

    if (p.includes('111111111')) {
      console.log(i);
      console.log(p);
    }

    if (plots.includes(p)) {
      console.log(plots.indexOf(p), plots.length);
      break;
    }

    plots.push(p);
  }
}

part2();
