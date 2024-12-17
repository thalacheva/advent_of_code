let A = 62769524
let B = 0
let C = 0
const program = [2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0]

function combo(A, B, C, val) {
  switch (val) {
    case 0:
    case 1:
    case 2:
    case 3:
      return val
    case 4:
      return A
    case 5:
      return B
    case 6:
      return C
    case 7:
      return 'invalid'
  }
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

const output = []

function part1() {
  let i = 0
  while (i < program.length) i = calc(i)

  return output.join(',')
}
