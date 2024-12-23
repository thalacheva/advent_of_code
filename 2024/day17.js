function combo(A, B, C, operand) {
  if (operand <= 3) return operand;
  if (operand === 4) return A;
  if (operand === 5) return B;
  if (operand === 6) return C;
}

const program = [2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0];

function part1(initialA, initialB) {
  let A = initialA, B = 0, C = 0

  let output = []
  let i = 0
  while (i < program.length) {
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
        if (A !== 0) {
          i = val
          continue
        }
        break
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
    i += 2
  }

  return output.join(',')
}

function calc(A) {
  let B = A % 8;
  B = B ^ 7;
  B = B ^ Math.floor(A / 2**B);
  B = B ^ 7;

  return B % 8;
}

function findA(A, output) {
  if (output.length === 0) {
    if (part1(A) === program.join(',')) console.log('Found ', A);
  } else {
    const val = output.pop();
    console.log(val, output);
    for (let i = 0; i < 8; i++) {
      if (calc(A * 8 + i) === val) {
        console.log('rem ', i, ' for val ', val);
        findA(A * 8 + i, [...output]);
      }
    }
  }
}

findA(0, [...program]);

console.log(part1(258394904430491));
console.log(part1(258395172865947));
