const fs = require('fs');
const data = fs.readFileSync('day11.txt', 'utf8').trim();

const regex = /(\d+)/g;
function blink(initial) {
  return initial.replace(regex, (match) => {
    if (match === '0') return '1';
    if (match.length % 2 === 0) {
      const left = match.slice(0, match.length / 2);
      const right = Number(match.slice(match.length / 2));
      return `${left} ${right}`;
    }
    return `${Number(match) * 2024}`;
  });
}

function part1() {
  let stones = data;
  for (let i = 0; i < 25; i++) {
    stones = blink(stones);
  }

  console.log(stones.match(regex).length);
}

// part1();

const map = new Map();
function transform25(stone) {
  if (map.has(stone)) return map.get(stone);

  let result = stone;
  for (let i = 0; i < 25; i++) {
    result = blink(result);
  }

  map.set(stone, result);
  return result;
}

const map2 = new Map();
const counter = data.split(' ').reduce((acc1, s1, i, array) => {
  console.log(acc1, s1, `(${i}/${array.length})`);
  return acc1 + transform25(s1).split(' ').reduce((acc2, s2, j, arr2) => {
    if (map2.has(s2)) return acc2 + map2.get(s2);

    const result = transform25(s2).split(' ').reduce((acc3, s3) => acc3 + transform25(s3).match(regex).length, 0)
    map2.set(s2, result);
    console.log('inner', result, s2, `(${j}/${arr2.length})`);

    return acc2 + result
  }, 0)}, 0);

console.log(counter);
