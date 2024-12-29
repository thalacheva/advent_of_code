const fs = require('fs');
const input = fs.readFileSync('day24.txt', 'utf-8').trim().split('\n');

const wires = new Map();
const gates = [];

for (const line of input) {
  if (line.includes(':')) {
    const [wire, value] = line.split(': ');
    wires.set(wire, Number(value));
  } else if (line.includes(' -> ')) {
    const [gate, output] = line.split(' -> ');
    const [wire1, op, wire2] = gate.split(' ');
    if (!wires.has(wire1)) wires.set(wire1, null);
    if (!wires.has(wire2)) wires.set(wire2, null);
    if (!wires.has(output)) wires.set(output, null);
    gates.push({ wire1, op, wire2, output });
  }
}

function swap(a, b) {
  let gateA = gates.find((g) => g.output === a);
  let gateB = gates.find((g) => g.output === b);

  gateA.output = b;
  gateB.output = a;
}

function getSignal(wire) {
  if (wires.get(wire) !== null) return wires.get(wire);

  const gate = gates.find((g) => g.output === wire);
  let signal;
  if (gate.op === 'AND') {
    signal = getSignal(gate.wire1) & getSignal(gate.wire2);
  } else if (gate.op === 'OR') {
    signal = getSignal(gate.wire1) | getSignal(gate.wire2);
  } else if (gate.op === 'XOR') {
    signal = (getSignal(gate.wire1) ^ getSignal(gate.wire2)) >>> 0;
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
      const bit = getSignal(wire);
      const power = Number(wire.slice(1));
      number += bit * (2 ** power);
    }
  }

  return number;
}

function findWrongWires(wires) {
  const wrongGates = gates.filter(g => wires.includes(g.output));
  if (wrongGates.length === 0) return [];

  const newWires = wrongGates.map(g => g.wire1).concat(wrongGates.map(g => g.wire2));

  return [...wires, ...newWires, ...findWrongWires(newWires)];
}

function check() {
  const x = findNumber(wires, 'x');
  const y = findNumber(wires, 'y');
  const z = findNumber(wires, 'z');

  return x + y === z;
}

// const x = findNumber(wires, 'x');
// const y = findNumber(wires, 'y');
// const z = findNumber(wires, 'z');

// console.log('0' + dec2bin(x + y));
// console.log(dec2bin(z));
// 45 total
// 31  30          19    15
// 0   10001001101 1000  0100011011100110
// 1   10001001101 0111  0100011011100110

swap('z31', 'z19');
// swap('z18', 'bss');
// swap('cpr', 'wgk');

const wrongWires = findWrongWires(['z18', 'z17', 'z16']).filter(w => !w.startsWith('x') && !w.startsWith('y'));
const unique = [...new Set(wrongWires)];
console.log(unique.join(','));
console.log(unique.length);
const mapXY = new Map(unique.map(w => [w, null]));
for (const wire of unique) {
  const gate = gates.find(g => g.output === wire);
  if ((gate.wire1.startsWith('x') || gate.wire1.startsWith('y')) && (gate.wire2.startsWith('x') || gate.wire2.startsWith('y'))) {
    mapXY.set(wire, getSignal(wire));
  }
}

console.log(mapXY);

const x = findNumber(wires, 'x');
const y = findNumber(wires, 'y');
const z = findNumber(wires, 'z');

console.log(dec2bin(x + y));
console.log(dec2bin(z));
