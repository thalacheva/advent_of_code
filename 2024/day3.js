const fs = require('node:fs');

const data = fs.readFileSync('day3.txt', 'utf8');
const regexp = /mul\((\d{1,3}),(\d{1,3})\)/g;

// Part 1
const groups = [...data.matchAll(regexp)].map(mul => ({value: mul[1] * mul[2], index: mul.index}));
// const result = groups.reduce((acc, mul) => acc + mul[1] * mul[2], 0);
// console.log(result);

// Part 2
const dontRegex = /don't\(\)/g;
const excludeFromIndexes = [...data.matchAll(dontRegex)].map(dont => dont.index).map(dont => ({include: false, index: dont}));
const doRegex = /do\(\)/g;
const includeFromIndexes = [...data.matchAll(doRegex)].map(do_ => do_.index).map(do_ => ({include: true, index: do_}));
const rules = [...excludeFromIndexes, ...includeFromIndexes].sort((a, b) => a.index - b.index);

let sum = 0;
for (const group of groups) {
  const validRules = rules.filter(rule => rule.index < group.index);
  if (validRules.length === 0 || validRules[validRules.length - 1].include) {
    sum += group.value;
  }
}

console.log(sum);
