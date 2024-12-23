const fs = require('fs');
const numbers = fs.readFileSync('day22.txt', 'utf-8').trim().split('\n').map(Number);

function mix(a, b) {
  return (a ^ b) >>> 0;
}

function prune(a) {
  return a % 16777216;
}

function next(number) {
  let result = prune(mix((number * 64), number));
  result = prune(mix(Math.trunc(result / 32), result));
  result = prune(mix(result * 2048, result));

  return result;
}

function part1() {
  const results = [];
  for (let number of numbers) {
    for (let i = 0; i < 2000; i++) {
      number = next(number);
    }
    results.push(number);
  }

  console.log(results.reduce((a, b) => a + b, 0));
}

function sequence(number) {
  const results = [{bananas: number % 10, change: null}];
  for (let i = 1; i <= 2000; i++) {
    number = next(number);
    results.push({bananas: number % 10, change: (number % 10) - results[i - 1].bananas});
  }

  return results;
}

function bananas(sequence, pattern) {
  const pat = pattern.split(',').map(Number);
  for (let i = 1; i < sequence.length - 4; i++) {
    if (sequence[i].change === pat[0] &&
        sequence[i + 1].change === pat[1] &&
        sequence[i + 2].change === pat[2] &&
        sequence[i + 3].change === pat[3]) {
      return sequence[i + 3].bananas;
    }
  }

  return 0;
}

function part2() {
  const results = [];
  const patterns = new Set();
  for (let number of numbers) {
    const seq = sequence(number);
    results.push(seq);
    for (let i = 1; i < seq.length - 4; i++) {
      const pattern = seq.slice(i, i + 4).map(s => s.change);
      if (pattern.reduce((a, b) => a + b, 0) > 0) patterns.add(pattern.join());
    }
  }

  let max = 0;
  for (pattern of patterns) {
    let sum = 0;
    for (let seq of results) {
      sum += bananas(seq, pattern);
    }
    max = Math.max(max, sum);
  }

  console.log(max);
}

part2();
