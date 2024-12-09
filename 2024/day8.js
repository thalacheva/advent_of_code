const fs = require('node:fs');

const data = fs.readFileSync('day8.txt', 'utf8').trim().split('\n').map(line => line.split(''));

function print(arr) {
  for (let i = 0; i < data.length; i++) {
    console.log(data[i].map((cell, j) => arr[i][j] || cell).join(''));
  }
  console.log();
}

function part1() {
  const antinodes = [...Array(data.length)].map(() => Array(data[0].length).fill(0));

  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data[i].length; j++) {
      if (data[i][j] !== '.') {
        for (let k = i; k < data.length; k++) {
          for (let l = 0; l < data[k].length; l++) {
            if (k === i && l <= j) continue;

            if (data[k][l] === data[i][j]) {
              const x = k - i;
              const y = l - j;
              if (i - x >= 0 && j - y >= 0 && j - y < data[i - x].length) antinodes[i - x][j - y] = '#';
              if (k + x < data.length && l + y < data[k + x].length && l + y >= 0) antinodes[k + x][l + y] = '#';
            }
          }
        }
      }
    }
  }

  print(antinodes);
  console.log(antinodes.flat().filter(x => x).length);
}

function part2() {
  const antinodes = [...Array(data.length)].map(() => Array(data[0].length).fill(0));
  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data[i].length; j++) {
      if (data[i][j] !== '.') {
        for (let k = i; k < data.length; k++) {
          for (let l = 0; l < data[k].length; l++) {
            if (k === i && l <= j) continue;

            if (data[k][l] === data[i][j]) {
              antinodes[i][j] = '#';
              antinodes[k][l] = '#';
              let x = k - i;
              let y = l - j;

              let m = 1;
              while (i - m * x >= 0 && j - m * y >= 0 && j - m * y < data[i - m * x].length) {
                antinodes[i - m * x][j - m * y] = '#';
                m++;
              }

              m = 1;
              while (k + m * x < data.length && l + m * y < data[k + m * x].length && l + m * y >= 0) {
                antinodes[k + m * x][l + m * y] = '#';
                m++;
              }
            }
          }
        }
      }
    }
  }

  print(antinodes);
  console.log(antinodes.flat().filter(x => x).length);
}

part2();
