const directions = [
  [0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
  [-1, 0],
  [-1, 1],
];

// Mirrors fire_spread/fire_spread_recur
export function fireTiles(range: number): Set<string> {
  const tiles = new Set<string>();
  if (range <= 0) {
    return tiles;
  }
  tiles.add('0,0');
  const visit = (
    x: number,
    y: number,
    remaining: number,
    direction: number,
  ) => {
    tiles.add(`${x},${y}`);
    for (const turn of [-1, 0, 1]) {
      const next = (direction + turn + 8) % 8;
      const [dx, dy] = directions[next];
      const power = remaining * (turn ? 0.75 : 1) - (dx && dy ? 1.414 : 1);
      if (power >= 1) {
        visit(x + dx, y + dy, power, next);
      }
    }
  };
  directions.forEach(([x, y], direction) => {
    visit(x, y, range - (x && y ? 1.414 : 1), direction);
  });
  return tiles;
}
