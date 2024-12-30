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

function swap(a, b) {
  let gateA = gates.find((g) => g.output === a);
  let gateB = gates.find((g) => g.output === b);

  gateA.output = b;
  gateB.output = a;
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

function findTree(wire) {
  if (wire.startsWith('x') || wire.startsWith('y')) return wire;

  const gate = gates.find((g) => g.output === wire);
  let op;
  if (gate.op === 'AND') {
    op = '&';
  } else if (gate.op === 'OR') {
    op = '|';
  } else if (gate.op === 'XOR') {
    op = '^';
  }

  const inWires = [gate.wire1, gate.wire2].sort()

  return `(${findTree(inWires[0])}${op}${findTree(inWires[1])})`;
}

function printTree() {
  for (let i = 0; i < 45; i++) {
    const z = `z${i.toString().padStart(2, '0')}`;
    console.log(`${z}:`, findTree(z));
  }
}

function generateSwaps(wires) {
  const manuallyFound = ['rrn', 'fkb', 'rdn'];
  const possible = [...wires.keys()].filter(w => !w.startsWith('x') && !w.startsWith('y') && !w.startsWith('z'));

  const swaps = [];
  for (let i = 0; i < possible.length; i++) {
    for (let j = i + 1; j < possible.length; j++) {
      if (manuallyFound.includes(possible[i]) || manuallyFound.includes(possible[j])) continue;

      swaps.push([possible[i], possible[j]]);
    }
  }

  return swaps;
}

function findSwaps(swaps) {
  for (let i = 0; i < swaps.length; i++) {
    try {
      swap(...swaps[i]);

      if (check()) console.log(swaps[i]);
    } catch (e) {
      continue;
    } finally {
      swap(...swaps[i]);
    }
  }
}

// Manually found swaps
swap('z37', 'rrn');
swap('z31', 'rdn');
swap('z16', 'fkb');

const swaps = generateSwaps(initialWires);

findSwaps(swaps);
swap('rqf', 'nnr');
printTree();

// fkb,nnr,rdn,rqf,rrn,z16,z31,z37
