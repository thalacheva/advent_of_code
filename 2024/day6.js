const fs = require('node:fs');

const data = fs.readFileSync('day6.txt', 'utf8').trim().split('\n').map(row => row.split(''));

function find_start() {
  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data[i].length; j++) {
      if (data[i][j] === '^') {
        return [i, j];
      }
    }
  }
}

function print(visited) {
  for (let i = 0; i < data.length; i++) {
    console.log(data[i].map((cell, j) => visited[i][j] || cell).join(''));
  }
  console.log();
}

function move(pos, direction) {
  const visited = [...Array(data.length)].map(() => Array(data[0].length).fill(false));
  const timesVisited = [...Array(data.length)].map(() => Array(data[0].length).fill(0));
  let [i, j] = pos;
  let directionRotated = 0;
  visited[i][j] = direction;
  timesVisited[i][j]++;

  while (i > 0 && i < data.length - 1 && j > 0 && j < data[i].length - 1) {
    if (direction === '^') {
      if (data[i - 1][j] === '#' || data[i - 1][j] === 'O') { direction = '>'; directionRotated++; }
      else { i--; directionRotated = 0; }
    } else if (direction === 'v') {
      if (data[i + 1][j] === '#' || data[i + 1][j] === 'O') { direction = '<'; directionRotated++; }
      else { i++; directionRotated = 0; }
    } else if (direction === '>') {
      if (data[i][j + 1] === '#' || data[i][j + 1] === 'O') { direction = 'v'; directionRotated++; }
      else { j++; directionRotated = 0; }
    } else if (direction === '<') {
      if (data[i][j - 1] === '#' || data[i][j - 1] === 'O') { direction = '^'; directionRotated++; }
      else { j--; directionRotated = 0; }
    }

    if (
      (visited[i][j] === direction && directionRotated === 0) || directionRotated > 3 ||
      (timesVisited[i][j] > 10000 &&
        ((visited[i][j] === '^' && direction === 'v' && directionRotated > 0) ||
        (visited[i][j] === 'v' && direction === '^' && directionRotated > 0) ||
        (visited[i][j] === '>' && direction === '<' && directionRotated > 0) ||
        (visited[i][j] === '<' && direction === '>' && directionRotated > 0))
      )
    ) {
      // console.log('-----looped-----');
      // print(visited);
      // print(timesVisited);

      return 'looped';
    }

    timesVisited[i][j]++;
    if (directionRotated === 0) visited[i][j] = direction;
  }

  return visited.flat().filter(Boolean).length;
}

// Part 1
// console.log(move(find_start(), '^'));

// Part 2
let obstacles = 0
for (let i = 0; i < data.length; i++) {
  for (let j = 0; j < data[i].length; j++) {
    if (data[i][j] === '#' || data[i][j] === '^') continue;

    data[i][j] = 'O';

    const result = move(find_start(), '^');
    // console.log(result);
    obstacles += result === 'looped';
    data[i][j] = '.';
  }
}

console.log('looping obstacles: ', obstacles);
