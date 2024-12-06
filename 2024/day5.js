const fs = require('node:fs');

const data = fs.readFileSync('day5.txt', 'utf8').trim().split('\n');
const rules = [];
const seqs = [];

for (let i = 0; i < data.length; i++) {
  if (data[i].includes('|')) {
    rules.push(data[i]);
  } else if (data[i].length > 0) {
    seqs.push(data[i].split(',').map(Number));
  }
}

function check(seq) {
  for (let i = 0; i < seq.length; i++) {
    for (let j = i + 1; j < seq.length; j++) {
      if (rules.includes(`${seq[j]}|${seq[i]}`)) return false;
    }
  }

  return true;
}

function sort(seq) {
  while (!check(seq)) {
    for (let i = 0; i < seq.length; i++) {
      for (let j = i + 1; j < seq.length; j++) {
        if (rules.includes(`${seq[j]}|${seq[i]}`)) {
          const temp = seq[j];
          seq.splice(j, 1)
          if (i === 0) seq.unshift(temp);
          else seq.splice(i-1, 0, temp);
        }
      }
    }
  }

  return seq;
}

// Part 1
let sum = 0;
const incorrect = [];
for (const seq of seqs) {
  if (check(seq)) sum += seq[Math.floor(seq.length / 2)];
  else incorrect.push(seq);
}
// console.log(sum);

// Part 2
sum = 0;
for (let seq of incorrect) {
  seq = sort(seq);
  sum += seq[Math.floor(seq.length / 2)];
}
console.log(sum);
