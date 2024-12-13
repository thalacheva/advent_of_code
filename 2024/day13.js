const fs = require('fs');
const regex = /\d+/g;
const data = fs.readFileSync('day13.txt', 'utf8').trim().split('\n')

const machines = []
for (let i = 0; i < data.length; i += 4) {
  machines.push({
    a: data[i].match(regex).map(Number),
    b: data[i + 1].match(regex).map(Number),
    price: data[i + 2].match(regex).map(Number),
  })
}

// Part 1
function win1(machine) {
  const [a, b] = machine.a
  const [c, d] = machine.b
  const [p, q] = machine.price

  let n = 0, m = 0

  while (a * n <= p && b * n <= q) {
    n++
    m = 0
    while (a * n + c * m <= p && b * n + d * m <= q) {
      m++
      if (a * n + c * m === p && b * n + d * m === q) {
        return [n, m]
      }
    }
  }

  return [0, 0]
}

let tokens = 0
for (const machine of machines) {
  const [n, m] = win1(machine)
  tokens += 3 * n + m
}
console.log("Part 1: ", tokens)

// Part 2
tokens = 0
function win2(machine) {
  const [a, b] = machine.a
  const [c, d] = machine.b
  const [p, q] = machine.price

  const det = a * d - b * c
  const x = d * p - c * q
  const y = -b * p + a * q

  if (det === 0 || x % det !== 0 || y % det !== 0) return [0, 0]

  return [x / det, y / det]
}

for (const machine of machines) {
  const [n, m] = win2({
    ...machine,
    price: [machine.price[0] + 10000000000000, machine.price[1] + 10000000000000]
  })
  tokens += 3 * n + m
}

console.log("Part 2: ", tokens)
