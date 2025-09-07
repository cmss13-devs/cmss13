import type { ReactNode } from 'react';

import type { BoxProps } from './Box';
import { Image } from './Image';

export enum Direction {
  NORTH = 1,
  SOUTH = 2,
  EAST = 4,
  WEST = 8,
  NORTHEAST = NORTH | EAST,
  NORTHWEST = NORTH | WEST,
  SOUTHEAST = SOUTH | EAST,
  SOUTHWEST = SOUTH | WEST,
}

type Props = {
  /** Required: The path of the icon */
  readonly icon: string;
  /** Required: The state of the icon */
  readonly icon_state: string;
} & Partial<{
  /** Facing direction. See direction enum. Default is South */
  direction: Direction;
  /** Fallback icon. */
  fallback: ReactNode;
  /** Frame number. Default is 1 */
  frame: number;
  /** Movement state. Default is false */
  movement: any;
}> &
  BoxProps;

/**
 * ## DmIcon
 *
 * Displays an icon from the BYOND icon reference map. Requires Byond 515+.
 * A much faster alternative to base64 icons.
 */
export function DmIcon(props: Props) {
  const {
    direction = Direction.SOUTH,
    fallback,
    frame = 1,
    icon_state,
    icon,
    movement = false,
    ...rest
  } = props;

  const iconRef = Byond.iconRefMap?.[icon];

  if (!iconRef) return fallback;

  const query = `${iconRef}?state=${icon_state}&dir=${direction}&movement=${!!movement}&frame=${frame}`;

  return <Image fixErrors src={query} {...rest} />;
}
