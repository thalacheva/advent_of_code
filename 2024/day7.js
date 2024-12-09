const fs = require('node:fs');

const data = fs.readFileSync('day7.txt', 'utf8').trim().split('\n');

function calculate(test, result, numbers) {
  if (numbers.length === 0) return test === result;
  if (test < result) return false;

  const [current, ...rest] = numbers;

  return calculate(test, result * current, rest) || calculate(test, result + current, rest);
}

function calculate2(test, result, numbers) {
  if (numbers.length === 0) return test === result;
  if (test < result) return false;

  const [current, ...rest] = numbers;

  return calculate2(test, result * current, rest) ||
         calculate2(test, result + current, rest) ||
         calculate2(test, Number(`${result}${current}`), rest);
}

let sum = 0;
for (let i = 0; i < data.length; i++) {
  const [test, numbers] = data[i].split(': ');
  const [first, ...rest] = numbers.split(' ').map(Number);
  // if (calculate(Number(test), first, rest)) sum += Number(test);
  if (calculate2(Number(test), first, rest)) sum += Number(test);
}

console.log(sum);
