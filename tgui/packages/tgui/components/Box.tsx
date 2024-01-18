/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes } from 'common/react';
import { createElement, ReactNode } from 'react';
import { CSS_COLORS } from '../constants';

export type BoxProps = {
  [key: string]: any;
  readonly as?: string;
  readonly className?: string | BooleanLike;
  readonly children?: ReactNode;
  readonly position?: string | BooleanLike;
  readonly overflow?: string | BooleanLike;
  readonly overflowX?: string | BooleanLike;
  readonly overflowY?: string | BooleanLike;
  readonly top?: string | BooleanLike;
  readonly bottom?: string | BooleanLike;
  readonly left?: string | BooleanLike;
  readonly right?: string | BooleanLike;
  readonly width?: string | BooleanLike;
  readonly minWidth?: string | BooleanLike;
  readonly maxWidth?: string | BooleanLike;
  readonly height?: string | BooleanLike;
  readonly minHeight?: string | BooleanLike;
  readonly maxHeight?: string | BooleanLike;
  readonly fontSize?: string | BooleanLike;
  readonly fontFamily?: string;
  readonly lineHeight?: string | BooleanLike;
  readonly opacity?: number;
  readonly textAlign?: string | BooleanLike;
  readonly verticalAlign?: string | BooleanLike;
  readonly inline?: BooleanLike;
  readonly bold?: BooleanLike;
  readonly italic?: BooleanLike;
  readonly nowrap?: BooleanLike;
  readonly preserveWhitespace?: BooleanLike;
  readonly m?: string | BooleanLike;
  readonly mx?: string | BooleanLike;
  readonly my?: string | BooleanLike;
  readonly mt?: string | BooleanLike;
  readonly mb?: string | BooleanLike;
  readonly ml?: string | BooleanLike;
  readonly mr?: string | BooleanLike;
  readonly p?: string | BooleanLike;
  readonly px?: string | BooleanLike;
  readonly py?: string | BooleanLike;
  readonly pt?: string | BooleanLike;
  readonly pb?: string | BooleanLike;
  readonly pl?: string | BooleanLike;
  readonly pr?: string | BooleanLike;
  readonly color?: string | BooleanLike;
  readonly textColor?: string | BooleanLike;
  readonly backgroundColor?: string | BooleanLike;
  readonly fillPositionedParent?: boolean;
};

/**
 * Coverts our rem-like spacing unit into a CSS unit.
 */
export const unit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    // Transparently convert pixels into rem units
    if (value.endsWith('px')) {
      return parseFloat(value) / 12 + 'rem';
    }
    return value;
  }
  if (typeof value === 'number') {
    return value + 'rem';
  }
};

/**
 * Same as `unit`, but half the size for integers numbers.
 */
export const halfUnit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    return unit(value);
  }
  if (typeof value === 'number') {
    return unit(value * 0.5);
  }
};

const isColorCode = (str: unknown) => !isColorClass(str);

const isColorClass = (str: unknown): boolean => {
  return typeof str === 'string' && CSS_COLORS.includes(str);
};

const mapRawPropTo = (attrName) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = value;
  }
};

const mapUnitPropTo = (attrName, unit) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = unit(value);
  }
};

const mapBooleanPropTo = (attrName, attrValue) => (style, value) => {
  if (value) {
    style[attrName] = attrValue;
  }
};

const mapDirectionalUnitPropTo = (attrName, unit, dirs) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    for (let i = 0; i < dirs.length; i++) {
      style[attrName + '-' + dirs[i]] = unit(value);
    }
  }
};

const mapColorPropTo = (attrName) => (style, value) => {
  if (isColorCode(value)) {
    style[attrName] = value;
  }
};

// String / number props
const stringStyleMap = {
  bottom: mapUnitPropTo('bottom', unit),
  fontFamily: mapRawPropTo('fontFamily'),
  fontSize: mapUnitPropTo('fontSize', unit),
  height: mapUnitPropTo('height', unit),
  left: mapUnitPropTo('left', unit),
  maxHeight: mapUnitPropTo('maxHeight', unit),
  maxWidth: mapUnitPropTo('maxWidth', unit),
  minHeight: mapUnitPropTo('minHeight', unit),
  minWidth: mapUnitPropTo('minWidth', unit),
  opacity: mapRawPropTo('opacity'),
  overflow: mapRawPropTo('overflow'),
  overflowX: mapRawPropTo('overflowX'),
  overflowY: mapRawPropTo('overflowY'),
  position: mapRawPropTo('position'),
  right: mapUnitPropTo('right', unit),
  textAlign: mapRawPropTo('textAlign'),
  top: mapUnitPropTo('top', unit),
  verticalAlign: mapRawPropTo('verticalAlign'),
  width: mapUnitPropTo('width', unit),

  lineHeight: (style, value) => {
    if (typeof value === 'number') {
      style['lineHeight'] = value;
    } else if (typeof value === 'string') {
      style['lineHeight'] = unit(value);
    }
  },
  // Margin
  m: mapDirectionalUnitPropTo('margin', halfUnit, [
    'Top',
    'Bottom',
    'Left',
    'Right',
  ]),
  mx: mapDirectionalUnitPropTo('margin', halfUnit, ['Left', 'Right']),
  my: mapDirectionalUnitPropTo('margin', halfUnit, ['Top', 'Bottom']),
  mt: mapUnitPropTo('marginTop', halfUnit),
  mb: mapUnitPropTo('marginBottom', halfUnit),
  ml: mapUnitPropTo('marginLeft', halfUnit),
  mr: mapUnitPropTo('marginRight', halfUnit),
  // Padding
  p: mapDirectionalUnitPropTo('padding', halfUnit, [
    'Top',
    'Bottom',
    'Left',
    'Right',
  ]),
  px: mapDirectionalUnitPropTo('padding', halfUnit, ['Left', 'Right']),
  py: mapDirectionalUnitPropTo('padding', halfUnit, ['Top', 'Bottom']),
  pt: mapUnitPropTo('paddingTop', halfUnit),
  pb: mapUnitPropTo('paddingBottom', halfUnit),
  pl: mapUnitPropTo('paddingLeft', halfUnit),
  pr: mapUnitPropTo('paddingRight', halfUnit),
  // Color props
  color: mapColorPropTo('color'),
  textColor: mapColorPropTo('color'),
  backgroundColor: mapColorPropTo('backgroundColor'),

  // Utility props
  fillPositionedParent: (style, value) => {
    if (value) {
      style['position'] = 'absolute';
      style['top'] = 0;
      style['bottom'] = 0;
      style['left'] = 0;
      style['right'] = 0;
    }
  },
} as const;

// Boolean props
const booleanStyleMap = {
  bold: mapBooleanPropTo('fontWeight', 'bold'),
  inline: mapBooleanPropTo('display', 'inline-block'),
  italic: mapBooleanPropTo('fontStyle', 'italic'),
  nowrap: mapBooleanPropTo('whiteSpace', 'nowrap'),
  preserveWhitespace: mapBooleanPropTo('whiteSpace', 'pre-wrap'),
} as const;

export const computeBoxProps = (props) => {
  const computedProps: Record<string, any> = {};
  const computedStyles: Record<string, string | number> = {};

  // Compute props
  for (let propName of Object.keys(props)) {
    if (propName === 'style') {
      continue;
    }

    const propValue = props[propName];

    const mapPropToStyle =
      stringStyleMap[propName] || booleanStyleMap[propName];

    if (mapPropToStyle) {
      mapPropToStyle(computedStyles, propValue);
    } else {
      computedProps[propName] = propValue;
    }
  }

  // Merge computed styles and any directly provided styles
  computedProps.style = { ...computedStyles, ...props.style };

  return computedProps;
};

export const computeBoxClassName = (props: BoxProps) => {
  const color = props.textColor || props.color;
  const backgroundColor = props.backgroundColor;
  return classes([
    isColorClass(color) && 'color-' + color,
    isColorClass(backgroundColor) && 'color-bg-' + backgroundColor,
  ]);
};

export const Box = (props: BoxProps) => {
  const { as = 'div', className, children, ...rest } = props;

  // Compute class name and styles
  const computedClassName = className
    ? `${className} ${computeBoxClassName(rest)}`
    : computeBoxClassName(rest);
  const computedProps = computeBoxProps(rest);

  if (as === 'img') {
    computedProps.style['-ms-interpolation-mode'] = 'nearest-neighbor';
  }

  // Render the component
  return createElement(
    typeof as === 'string' ? as : 'div',
    {
      ...computedProps,
      className: computedClassName,
    },
    children
  );
};
