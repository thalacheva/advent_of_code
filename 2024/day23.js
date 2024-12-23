const fs = require('fs');
const input = fs.readFileSync('day23.txt', 'utf-8').trim().split('\n');

const graph = new Map();

for (const line of input) {
  const [from, to] = line.split('-');
  graph.set(from, new Set([...(graph.get(from) || []), to]));
  graph.set(to, new Set([...(graph.get(to) || []), from]));
}

function findAllTriangles(graph, start) {
  const triangles = new Set();
  const neighbors = graph.get(start);

  for (const neighbor of neighbors) {
    for (const secondNeighbor of graph.get(neighbor)) {
      if (secondNeighbor === start) continue;

      if (graph.get(secondNeighbor).has(start)) {
        triangles.add([start, neighbor, secondNeighbor].sort().join());
      }
    }
  }

  return triangles;
}

function part1() {
  let cycles = new Set();
  for (const [key, value] of graph) {
    if (key.startsWith('t')) {
      cycles = new Set([...cycles, ...findAllTriangles(graph, key)]);
    }
  }

  console.log(cycles);
  console.log(cycles.size);
}

// part1();

function allConnected(graph, connected) {
  for (const [node, neighbors] of graph) {
    if (connected.has(node)) continue;

    if (connected.difference(neighbors).size === 0) {
      return allConnected(graph, new Set([...connected, node]));
    }
  }

  return connected;
}

function part2() {
  let cycles = new Set();
  for (const [key, value] of graph) {
    cycles = new Set([...cycles, ...findAllTriangles(graph, key)]);
  }

  let maxConnected = new Set();
  for (const cycle of cycles) {
    const result = allConnected(graph, new Set(cycle.split(',')));
    if (result.size > maxConnected.size) {
      maxConnected = result;
    }
  }

  console.log('MAX ', [...maxConnected].sort().join());
}

part2();
