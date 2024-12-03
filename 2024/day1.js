const fs = require('node:fs');

const data = fs.readFileSync('day1.txt', 'utf8').trim().split('\n');
let left = [], right = [];

for (const line of data) {
  const [a, b] = line.split('  ').map(Number);
  left.push(a);
  right.push(b);
}

// Part 2

let sim = 0
for (const c of left) {
  const d = right.filter(r => r === c).length
  sim += c * d
}
console.log(sim)

// Part 1

left.sort((a, b) => a - b);
right.sort((a, b) => a - b);

const diff = left.reduce((acc, val, i) => acc + Math.abs(val - right[i]), 0);

console.log(diff);
