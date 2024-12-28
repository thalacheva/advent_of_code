const fs = require('fs');
const input = fs.readFileSync('day25.txt', 'utf-8').trim().split('\n');

const locks = [];
const keys = [];

function add(input, start) {
  const lock = new Array(5).fill(0);
  for (let i = start + 1; i < start + 6; i++) {
    for (let j = 0; j < input[i].length; j++) {
      if (input[i][j] === '#') lock[j]++;
    }
  }

  return lock;
}

let i = 0;
while (i < input.length) {
  if (input[i].startsWith('#')) {
    locks.push(add(input, i));
  } else if (input[i].startsWith('.')) {
    keys.push(add(input, i));
  }
  i += 8;
}

let fits = 0
for (let i = 0; i < keys.length; i++) {
  for (let j = 0; j < locks.length; j++) {
    let match = true;
    for (let k = 0; k < 5; k++) {
      if (keys[i][k] + locks[j][k] > 5) {
        match = false;
        break;
      }
    }
    if (match) fits++;
  }
}

console.log(fits);
