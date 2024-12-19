const fs = require('fs');
const input = fs.readFileSync('day19.txt', 'utf-8').trim().split('\n');

const patterns = input[0].split(', ');
const designs = input.slice(2);

function part1() {
  const parts = new Map();

  function isPossible(patterns, design) {
    if (parts.has(design)) return parts.get(design);
    if (design === '') return true;
    if (patterns.length === 0) return false;

    return patterns.filter(p => design.startsWith(p)).some(p => {
      const rest = design.slice(p.length);
      const poss = isPossible(patterns.filter(p => design.includes(p)), rest)
      parts.set(rest, poss);

      return poss;
    });
  }

  return designs.reduce((acc, design) => acc + isPossible(patterns, design), 0);
}

function part2() {
  const parts = new Map();

  function isPossible(patterns, design) {
    if (parts.has(design)) return parts.get(design);
    if (patterns.length === 0) return 0;
    if (design === '') return 1;

    const startsWith = patterns.filter(p => design.startsWith(p));
    const included = patterns.filter(p => design.includes(p))

    let variations = 0;
    for (let i = 0; i < startsWith.length; i++) {
      const rest = design.slice(startsWith[i].length);
      variations += isPossible(included, rest);
    }

    parts.set(design, variations);

    return variations;
  }

  return designs.reduce((acc, design) => acc + isPossible(patterns, design), 0);
}

console.log(part1());
console.log(part2());
