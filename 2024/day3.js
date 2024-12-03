const fs = require('node:fs');

const data = fs.readFileSync('day3.txt', 'utf8')
const regexp = /mul\((\d{1,3}),(\d{1,3})\)/g

const groups = [...data.matchAll(regexp)];
const result = groups.reduce((acc, mul) => acc + mul[1] * mul[2], 0);
console.log(result);
