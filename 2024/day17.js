let A = 62769524
let B = 0
let C = 0
const program = [2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0]

function combo(A, B, C, operand) {
  if (operand <= 3) return operand;
  if (operand === 4) return A;
  if (operand === 5) return B;
  if (operand === 6) return C;
  throw new Error("Invalid operand");
}

function calc(i) {
  const op = program[i]
  const val = program[i + 1]

  switch (op) {
    case 0:
      A = Math.floor(A / 2**combo(A, B, C, val))
      break
    case 1:
      B = B ^ val
      break
    case 2:
      B = combo(A, B, C, val) % 8
      break
    case 3:
      if (A !== 0) return val
    case 4:
      B = B ^ C
      break
    case 5:
      output.push(combo(A, B, C, val) % 8)
      break
    case 6:
      B = Math.floor(A / 2**combo(A, B, C, val))
      break
    case 7:
      C = Math.floor(A / 2**combo(A, B, C, val))
      break
  }

  return i + 2
}

let output = []

function part1() {
  let i = 0
  while (i < program.length) {
    if (i === 0) console.log(A, B, C)
    i = calc(i)
  }

  return output.join(',')
}

// part1()

function init(startA) {
  A = startA
  B = 0
  C = 0
  output = []
}

function compare(output, program) {
  for (let i = 0; i < output.length; i++) {
    if (output[i] !== program[i]) return false
  }

  return true
}

function part2() {
  let startA = 328941096
  init(startA)
  while (output.join(',') !== program.join(',')) {
    startA++
    init(startA)
    let i = 0
    while (i < program.length && compare(output, program)) i = calc(i)
    console.log(startA)
  }

  return startA
}

function findA(program) {
  let output = [...program];
  let i = program.length - 2;
  let A = 0, B = 0, C = 0;

  while (output.length > 0) {
    const opcode = program[i];
    const val = program[i + 1];
    console.log(output);

    switch (opcode) {
      case 0:
        if (A === 0) A = 1;
        else A *= Math.pow(2, combo(val, A, B, C));
        break;
      case 1:
        B ^= val;
        break;
      case 2:
        B = (B + 8) % 8;
        break;
      case 3:
        break;
      case 4:
        B ^= C;
        break;
      case 5:
        const rem = output.pop();
        if (B === 0) {
          B = rem;
        } else {
          while (B % 8 !== rem) B++;
        }
        break;
      case 6:
        B *= Math.pow(2, combo(val, A, B, C));
        break;
      case 7:
        C *= Math.pow(2, combo(val, A, B, C));
        break;
    }

    i -= 2;
    if (i < 0) i = program.length - 2;
  }

  return A;
}

console.log("Value of A:", findA(program));
