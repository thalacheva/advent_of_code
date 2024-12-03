const fs = require('node:fs');

const data = fs.readFileSync('day2.txt', 'utf8').trim().split('\n');

const analyze = (line) => {
  const report = line.split(' ').map(Number);

  const increasing = report.every((val, i, arr) => i === 0 || val >= arr[i - 1]);
  const decreasing = report.every((val, i, arr) => i === 0 || val <= arr[i - 1]);
  const gradual = report.every((val, i, arr) => i === 0 || Math.abs(val - arr[i - 1]) >= 1 && Math.abs(val - arr[i - 1]) <= 3);

  return (increasing || decreasing) && gradual;
}

let safe = data.reduce((acc, val) => acc + analyze(val), 0);
console.log('part 1: ', safe);

const unsafe_reports = data.filter((val) => !analyze(val));

unsafe_reports.forEach((line) => {
  const report = line.split(' ').map(Number);

  for (let i = 0; i < report.length; i++) {
    const copy = [...report];
    copy.splice(i, 1);

    if (analyze(copy.join(' '))) {
      safe++;
      break;
    }
  }
});

console.log('part 2: ', safe);
