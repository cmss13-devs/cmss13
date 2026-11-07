// Follows explosion/get_propagation_dirs
export function blastPower(
  x: number,
  y: number,
  power: number,
  falloff: number,
  exponential: boolean,
): number {
  const diagonalSteps = Math.min(Math.abs(x), Math.abs(y));
  const cardinalSteps = Math.max(Math.abs(x), Math.abs(y)) - diagonalSteps;
  for (let step = 0; step < cardinalSteps + diagonalSteps; step++) {
    const distance = step === 0 ? 0 : step < cardinalSteps ? 1 : 1.414;
    power -= falloff * distance;
    if (power <= 0) {
      return 0;
    }
    if (exponential) {
      falloff *= 1 + distance;
    }
  }
  return power;
}
