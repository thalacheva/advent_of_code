const fs = require('node:fs');
const carta = fs.readFileSync('day10.txt', 'utf8').trim().split('\n').map(line => line.split('').map(Number));

let score = 0;
function find_path(i, j, data) {
  if (data[i][j] === 9) {
    score++;
    // data[i][j] = -1;
    return;
  }
  if (i + 1 < data.length && data[i][j] + 1 === data[i + 1][j]) find_path(i + 1, j, data);
  if (i - 1 >= 0 && data[i][j] + 1 === data[i - 1][j]) find_path(i - 1, j, data);
  if (j + 1 < data[i].length && data[i][j] + 1 === data[i][j + 1]) find_path(i, j + 1, data);
  if (j - 1 >= 0 && data[i][j] + 1 === data[i][j - 1]) find_path(i, j - 1, data);
}

for (let i = 0; i < carta.length; i++) {
  for (let j = 0; j < carta[i].length; j++) {
    const copy = carta.map(row => [...row]);
    if (carta[i][j] === 0) find_path(i, j, copy);
  }
}

console.log(score);
