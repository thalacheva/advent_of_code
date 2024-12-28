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

function getSignal(wire) {
  if (wires.get(wire) !== null) return wires.get(wire);

  const gate = gates.find((g) => g.output === wire);
  let signal;
  if (gate.op === 'AND') {
    signal = getSignal(gate.wire1) & getSignal(gate.wire2);
  } else if (gate.op === 'OR') {
    signal = getSignal(gate.wire1) | getSignal(gate.wire2);
  } else if (gate.op === 'XOR') {
    signal = getSignal(gate.wire1) ^ getSignal(gate.wire2);
  }

  wires.set(wire, signal);

  return signal;
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

console.log('x = ', findNumber(wires, 'x'));
console.log('y = ', findNumber(wires, 'y'));
console.log('x + y = ', findNumber(wires, 'x') + findNumber(wires, 'y'));
console.log('z = ', findNumber(wires, 'z'));
