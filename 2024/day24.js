const fs = require('fs');
const input = fs.readFileSync('day24.txt', 'utf-8').trim().split('\n');

const initialWires = new Map();
const gates = [];

for (const line of input) {
  if (line.includes(':')) {
    const [wire, value] = line.split(': ');
    initialWires.set(wire, Number(value));
  } else if (line.includes(' -> ')) {
    const [gate, output] = line.split(' -> ');
    const [wire1, op, wire2] = gate.split(' ');
    if (!initialWires.has(wire1)) initialWires.set(wire1, null);
    if (!initialWires.has(wire2)) initialWires.set(wire2, null);
    if (!initialWires.has(output)) initialWires.set(output, null);
    gates.push({ wire1, op, wire2, output });
  }
}

function getSignal(wires, wire) {
  if (wires.get(wire) !== null) return wires.get(wire);

  const gate = gates.find((g) => g.output === wire);
  let signal;
  if (gate.op === 'AND') {
    signal = getSignal(wires, gate.wire1) & getSignal(wires, gate.wire2);
  } else if (gate.op === 'OR') {
    signal = getSignal(wires, gate.wire1) | getSignal(wires, gate.wire2);
  } else if (gate.op === 'XOR') {
    signal = getSignal(wires, gate.wire1) ^ getSignal(wires, gate.wire2);
  }

  wires.set(wire, signal);

  return signal;
}

function dec2bin(dec) {
  return (dec >>> 0).toString(2);
}

function bin2dec(bin) {
  return parseInt(bin, 2);
}

function findNumber(wires, prefix) {
  let number = 0;

  for (const wire of wires.keys()) {
    if (wire.startsWith(prefix)) {
      const bit = getSignal(wires, wire);
      const power = Number(wire.slice(1));
      number += bit * (2 ** power);
    }
  }

  return number;
}

function generateSwaps(wires) {
  const possible = [...wires.keys()].filter(w => !w.startsWith('x') && !w.startsWith('y'));

  const swaps = [];
  for (let i = 0; i < possible.length; i++) {
    for (let j = i + 1; j < possible.length; j++) {
      swaps.push([possible[i], possible[j]]);
    }
  }

  return swaps;
}

function swap(a, b) {
  let gateA = gates.find((g) => g.output === a);
  let gateB = gates.find((g) => g.output === b);

  gateA.output = b;
  gateB.output = a;
}

function check() {
  for (let i = 0; i < 10; i++) {
    const wires = randomizeWires(initialWires);
    const x = findNumber(wires, 'x');
    const y = findNumber(wires, 'y');
    const z = findNumber(wires, 'z');
    if (x + y !== z) return false;
  }

  return true;
}

function findSwaps(swaps) {
  for (let i = 0; i < swaps.length; i++) {
    for (let j = i + 1; j < swaps.length; j++) {
      for (let k = j + 1; k < swaps.length; k++) {
        for (let l = k + 1; l < swaps.length; l++) {
          const set = new Set([...swaps[i], ...swaps[j], ...swaps[k], ...swaps[l]]);
          if (set.size !== 8) continue;
          if ([...set].filter(s => s.startsWith('z')).length < 3) continue;

          try {
            swap(...swaps[i]);
            swap(...swaps[j]);
            swap(...swaps[k]);
            swap(...swaps[l]);

            if (check()) {
              console.log('Found solution: ', swaps[i], swaps[j], swaps[k], swaps[l]);
              console.log([...swaps[i], ...swaps[j], ...swaps[k], ...swaps[l]].sort().join());
            }
          } catch (e) {
            continue;
          } finally {
            swap(...swaps[i]);
            swap(...swaps[j]);
            swap(...swaps[k]);
            swap(...swaps[l]);
          }
        }
      }
    }
  }
}

function findWrongBits(wires, x, y) {
  const z = findNumber(wires, 'z');
  const result = dec2bin(z).split('').reverse().join('');
  const expected = dec2bin(x + y).split('').reverse().join('') + '0';

  const wrongBits = [];
  for (let i = 0; i < result.length; i++) {
    if (result[i] !== expected[i]) wrongBits.push('z' + i);
  }

  return wrongBits;
}

function getRandomBit() {
  return Math.floor(Math.random() * 2);
}

function randomizeWires(wires) {
  const random = new Map(wires);
  for (const wire of random.keys()) {
    if (wire.startsWith('x') || wire.startsWith('y')) {
      random.set(wire, getRandomBit());
    }
  }

  return random;
}

function findGoodSwaps(startWires, allSwaps) {
  let wires = new Map(startWires);
  const x = findNumber(wires, 'x');
  const y = findNumber(wires, 'y')
  const wrongWires = findWrongBits(wires, x, y);

  if (wrongWires.length < 5) return allSwaps;

  const goodSwaps = [];
  for (const s of allSwaps) {
    try {
      swap(...s);
      const wrongWires2 = findWrongBits(new Map(startWires), x, y);
      if (wrongWires2.length < wrongWires.length) goodSwaps.push(s);
    } catch (e) {
      continue;
    } finally {
      swap(...s);
    }
  }

  return [...goodSwaps];
}

function findWrongWires(wires) {
  const wrongGates = gates.filter(g => wires.includes(g.output));
  if (wrongGates.length === 0) return [];

  const newWires = wrongGates.map(g => g.wire1).concat(wrongGates.map(g => g.wire2)).
                    filter(w => !wires.startsWith('x') && !wires.startsWith('y'));

  return new Set([...wires, ...newWires, ...findWrongWires(newWires)]);
}

let wires = new Map(initialWires);
const allSwaps = generateSwaps(wires);

let goodSwaps = findGoodSwaps(wires, allSwaps);
console.log('Initially found ', goodSwaps.length);

for (let i = 0; i < 5; i++) {
  wires = randomizeWires(initialWires);
  goodSwaps = findGoodSwaps(wires, goodSwaps);
  console.log('Iteration ', i, goodSwaps.length);
}

console.log(goodSwaps);
console.log(goodSwaps.length);

findSwaps(goodSwaps);

// const x = findNumber(wires, 'x');
// const y = findNumber(wires, 'y');
// swap('bss', 'grr')
// swap('crp', 'tnn' )
// swap('gkk', 'tjk')
// swap('z16', 'fvv')
// const z = findNumber(wires, 'z');
// console.log(z);
// console.log(x + y);
// console.log(dec2bin(z));
// console.log(dec2bin(x + y));
