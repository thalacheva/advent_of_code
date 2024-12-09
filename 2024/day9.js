const fs = require('node:fs');
const data = fs.readFileSync('day9.txt', 'utf8').split('').map(Number);

const disk = [];
for (let i = 0; i < data.length; i++) {
  if (i % 2 === 0) {
    for (let j = 0; j < data[i]; j++) {
      disk.push(i / 2);
    }
  } else {
    for (let j = 0; j < data[i]; j++) {
      disk.push('.');
    }
  }
}

console.log(disk.join(''));

function compress1(disk) {
  let n = disk.length - 1;

  for (let i = 0; i < disk.length; i++) {
    if (disk[i] === '.') {
      while (disk[n] === '.' && n > i) n--;
      disk[i] = disk[n];
      disk[n] = '.';
    }
  }
  return disk;
}

function compress2(disk) {
  const freeSpaces = [];
  const usedSpaces = [];
  let k = 0;
  while (k < disk.length) {
    let size = 1;

    if (disk[k] === '.') {
      while (disk[k + size] === '.') size++;
      freeSpaces.push({ start: k, size });
    } else {
      while (disk[k + size] === disk[k]) size++;
      usedSpaces.push({ start: k, size });
    }

    k += size;
  }

  for (let i = usedSpaces.length - 1; i >= 0; i--) {
    const { start, size } = usedSpaces[i];
    const freeSpace = freeSpaces.find((space) => space.size >= size);
    if (freeSpace && freeSpace.start < start) {
      for (let j = 0; j < size; j++) {
        disk[freeSpace.start + j] = disk[start + j];
        disk[start + j] = '.';
      }
      freeSpace.size -= size;
      freeSpace.start += size;
      if (freeSpace.size === 0) freeSpaces.splice(freeSpaces.indexOf(freeSpace), 1);
    }
  }


  return disk;
}

function checksum(disk) {
  let sum = 0;
  let i = 0;

  while (disk[i] !== '.') {
    sum += disk[i] * i;
    i++;
  }

  return sum;
}

function checksum2(disk) {
  let sum = 0;

  for (let i = 0; i < disk.length; i++) {
    if (disk[i] !== '.') sum += disk[i] * i;
  }

  return sum;
}

compress2(disk);
console.log(disk.join(''));
console.log(checksum2(disk));
