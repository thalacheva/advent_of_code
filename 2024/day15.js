const fs = require('fs');

const data = fs.readFileSync('day15.txt', 'utf8').trim().split('\n');
const map = [];
const movements = [];

let readingMap = true;
for (let i = 0; i < data.length; i++) {
  if (data[i] === '') readingMap = false;
  else if (readingMap) map.push(data[i].split(''));
  else movements.push(...data[i].split(''));
}

function plot(map) {
  for (let i = 0; i < map.length; i++) console.log(map[i].join(''));
}

function findStart(map) {
  for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[i].length; j++) {
      if (map[i][j] === '@') return { x: j, y: i };
    }
  }
}

function transform(map) {
  const map2 = [];
  for (let i = 0; i < map.length; i++) {
    map2.push([]);
    for (let j = 0; j < map[i].length; j++) {
      if (map[i][j] === '#') map2[i].push('#', '#');
      else if (map[i][j] === 'O') map2[i].push('[', ']');
      else if (map[i][j] === '.') map2[i].push('.', '.');
      else if (map[i][j] === '@') map2[i].push('@', '.');
    }
  }

  return map2;
}

function part1() {
  function move(x, y, direction) {
    const current = { x, y };

    switch (direction) {
      case '>':
        if (map[y][x + 1] === '.') {
          map[y][x] = '.';
          map[y][x + 1] = '@';
          current.x++;
        } else if (map[y][x + 1] === 'O') {
          let free = x + 2;
          while (map[y][free] === 'O' && free < map[y].length - 1) free++;
          if (map[y][free] === '.') {
            map[y][x] = '.';
            map[y][x + 1] = '@';
            map[y][free] = 'O';
            current.x++;
          }
        }
        break;
      case '<':
        if (map[y][x - 1] === '.') {
          map[y][x] = '.';
          map[y][x - 1] = '@';
          current.x--;
        } else if (map[y][x - 1] === 'O') {
          let free = x - 2;
          while (map[y][free] === 'O' && free > 0) free--;
          if (map[y][free] === '.') {
            map[y][x] = '.';
            map[y][x - 1] = '@';
            map[y][free] = 'O';
            current.x--;
          }
        }
        break;
      case '^':
        if (map[y - 1][x] === '.') {
          map[y][x] = '.';
          map[y - 1][x] = '@';
          current.y--;
        } else if (map[y - 1][x] === 'O') {
          let free = y - 2;
          while (map[free][x] === 'O' && free > 0) free--;
          if (map[free][x] === '.') {
            map[y][x] = '.';
            map[y - 1][x] = '@';
            map[free][x] = 'O';
            current.y--;
          }
        }
        break;
      case 'v':
        if (map[y + 1][x] === '.') {
          map[y][x] = '.';
          map[y + 1][x] = '@';
          current.y++;
        } else if (map[y + 1][x] === 'O') {
          let free = y + 2;
          while (map[free][x] === 'O' && free < map.length - 1) free++;
          if (map[free][x] === '.') {
            map[y][x] = '.';
            map[y + 1][x] = '@';
            map[free][x] = 'O';
            current.y++;
          }
        }
        break;
    }

    return current;
  }

  let position = findStart(map);
  for (let i = 0; i < movements.length; i++) {
    position = move(position.x, position.y, movements[i]);
  }

  plot(map);

  let gps = 0;
  for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[i].length; j++) {
      if (map[i][j] === 'O') gps += i * 100 + j;
    }
  }
  console.log(gps);
}

function isPackage(position) {
  return position === '[' || position === ']';
}

function findAffectedPackagesUp(map, packages) {
  newPackages = [];

  for (package of packages) {
    let i = package.y - 1;
    if (map[i][package.x] === '[') newPackages.push({ x: package.x, y: i }, { x: package.x + 1, y: i});
    else if (map[i][package.x] === ']') newPackages.push({ x: package.x - 1, y: i}, { x: package.x, y: i });
  }

  return newPackages;
}

function findAffectedPackagesDown(map, packages) {
  newPackages = [];

  for (package of packages) {
    let i = package.y + 1;
    if (map[i][package.x] === '[') newPackages.push({ x: package.x, y: i }, { x: package.x + 1, y: i});
    else if (map[i][package.x] === ']') newPackages.push({ x: package.x - 1, y: i}, { x: package.x, y: i });
  }

  return newPackages;
}

function moveAffectedPackagesUp(map, x, y) {
  const packages = [];
  let i = y - 1;
  if (map[i][x] === '[') packages.push({ x, y: i }, { x: x + 1, y: i});
  else if (map[i][x] === ']') packages.push({ x: x - 1, y: i}, { x, y: i });

  let newPackages = packages;
  while (newPackages.length) {
    newPackages = findAffectedPackagesUp(map, newPackages);
    packages.push(...newPackages);
  }

  const canMove = packages.every(p => map[p.y - 1][p.x] !== '#');

  if (canMove) {
    const packagesWithPosition = packages.map(p => ({ ...p, position: map[p.y][p.x] }));
    for (package of packagesWithPosition.reverse()) {
      map[package.y - 1][package.x] = package.position;
      map[package.y][package.x] = '.';
    }
  }

  return canMove;
}

function moveAffectedPackagesDown(map, x, y) {
  const packages = [];
  let i = y + 1;
  if (map[i][x] === '[') packages.push({ x, y: i }, { x: x + 1, y: i});
  else if (map[i][x] === ']') packages.push({ x, y: i }, { x: x - 1, y: i});

  let newPackages = packages;
  while (newPackages.length) {
    newPackages = findAffectedPackagesDown(map, newPackages);
    packages.push(...newPackages);
  }

  const canMove = packages.every(p => map[p.y + 1][p.x] !== '#');

  if (canMove) {
    const packagesWithPosition = packages.map(p => ({ ...p, position: map[p.y][p.x] }));
    for (package of packagesWithPosition.reverse()) {
      map[package.y + 1][package.x] = package.position;
      map[package.y][package.x] = '.';
    }
  }

  return canMove;
}

function part2() {
  const map2 = transform(map);

  plot(map2);

  function move(x, y, direction) {
    const current = { x, y };

    switch (direction) {
      case '>':
        if (map2[y][x + 1] === '.') {
          map2[y][x] = '.';
          map2[y][x + 1] = '@';
          current.x++;
        } else if (map2[y][x + 1] === '[') {
          let free = x + 2;
          while (isPackage(map2[y][free]) && free < map2[y].length) free++;
          if (map2[y][free] === '.') {
            for (let i = free; i > x + 1; i--) map2[y][i] = map2[y][i - 1];
            map2[y][x + 1] = '@';
            map2[y][x] = '.';
            current.x++;
          }
        }
        break;
      case '<':
        if (map2[y][x - 1] === '.') {
          map2[y][x] = '.';
          map2[y][x - 1] = '@';
          current.x--;
        } else if (map2[y][x - 1] === ']') {
          let free = x - 2;
          while (isPackage(map2[y][free]) && free > 0) free--;
          if (map2[y][free] === '.') {
            for (let i = free; i < x - 1; i++) map2[y][i] = map2[y][i + 1];
            map2[y][x - 1] = '@';
            map2[y][x] = '.';
            current.x--;
          }
        }
        break;
      case '^':
        if (map2[y - 1][x] === '.') {
          map2[y][x] = '.';
          map2[y - 1][x] = '@';
          current.y--;
        } else if (isPackage(map2[y - 1][x])) {
          if (moveAffectedPackagesUp(map2, x, y)) {
            map2[y][x] = '.';
            map2[y - 1][x] = '@';
            current.y--;
          }
        }
        break;
      case 'v':
        if (map2[y + 1][x] === '.') {
          map2[y][x] = '.';
          map2[y + 1][x] = '@';
          current.y++;
        } else if (isPackage(map2[y + 1][x])) {
          if (moveAffectedPackagesDown(map2, x, y)) {
            map2[y][x] = '.';
            map2[y + 1][x] = '@';
            current.y++;
          }
        }
        break;
    }

    return current;
  }

  let position = findStart(map2);
  for (let i = 0; i < movements.length; i++) {
    position = move(position.x, position.y, movements[i]);
    // console.log(movements[i]);
    // plot(map2);
  }

  plot(map2);

  let gps = 0;
  for (let i = 0; i < map2.length; i++) {
    for (let j = 0; j < map2[i].length; j++) {
      if (map2[i][j] === '[') gps += i * 100 + j;
    }
  }
  console.log(gps);
}

// part1();
part2();
