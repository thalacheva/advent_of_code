const fs = require('node:fs');

const data = fs.readFileSync('day4.txt', 'utf8').trim().split('\n').map(line => line.split(''));

// Part 1
function part1(data) {
  let matches = 0;
  let pattern = ['X', 'M', 'A', 'S'];

  function check_right(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (j + k >= data[i].length || data[i][j + k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_down(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i + k >= data.length || data[i + k][j] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_left(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (j - k < 0 || data[i][j - k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_up(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i - k < 0 || data[i - k][j] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_left_up(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i - k < 0 || j - k < 0 || data[i - k][j - k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_right_down(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i + k >= data.length || j + k >= data[i].length || data[i + k][j + k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_left_down(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i + k >= data.length || j - k < 0 || data[i + k][j - k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  function check_right_up(i, j) {
    for (let k = 0; k < pattern.length; k++) {
      if (i - k < 0 || j + k >= data[i].length || data[i - k][j + k] !== pattern[k]) {
        return false;
      }
    }
    return true;
  }

  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data[i].length; j++) {
      if (data[i][j] === 'X') {
        matches += check_right(i, j) + check_down(i, j) + check_left(i, j) + check_up(i, j) + check_left_up(i, j) + check_right_down(i, j) + check_left_down(i, j) + check_right_up(i, j);
      }
    }
  }

  return matches;
}

// console.log(part1(data));

// Part 2

function part2(data) {
  let matches = 0

  function pattern(i, j, pattern) {
    const letters = pattern.split('');

    return i - 1 >= 0 && j - 1 >= 0 && data[i - 1][j - 1] === letters[0] &&
           i - 1 >= 0 && j + 1 < data[i].length && data[i - 1][j + 1] === letters[1] &&
           i + 1 < data.length && j - 1 >= 0 && data[i + 1][j - 1] === letters[2] &&
           i + 1 < data.length && j + 1 < data[i].length && data[i + 1][j + 1] === letters[3];
  }

  for (let i = 0; i < data.length; i++) {
    for (let j = 0; j < data[i].length; j++) {
      if (data[i][j] === 'A') {
        if (pattern(i, j, 'MMSS')) matches++;
        if (pattern(i, j, 'SSMM')) matches++;
        if (pattern(i, j, 'MSMS')) matches++;
        if (pattern(i, j, 'SMSM')) matches++;
      }
    }
  }

  return matches;
}

console.log(part2(data));
