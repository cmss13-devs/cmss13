import type { Channel } from './ChannelIterator';
import {
  LIVING_TYPES,
  type LivingType,
  RADIO_PREFIXES,
  RADIO_PREFIXES_MAP,
  SMALL_WINDOW_SIZE,
  WIDTH_WINDOW_SIZE,
} from './constants';

/**
 * Once byond signals this via keystroke, it
 * ensures window size, visibility, and focus.
 */
export function windowOpen(channel: Channel, scale: boolean): void {
  setWindowVisibility(true, scale);
  Byond.sendMessage('open', { channel });
}

/**
 * Resets the state of the window and hides it from user view.
 * Sending "close" logs it server side.
 */
export function windowClose(scale: boolean): void {
  setWindowVisibility(false, scale);
  Byond.winset('map', {
    focus: true,
  });
  Byond.sendMessage('close');
}

/**
 * Modifies the window size.
 */
export function windowSet(size = SMALL_WINDOW_SIZE, scale: boolean): void {
  const pixelRatio = scale ? window.devicePixelRatio : 1;

  const sizeStr = `${WIDTH_WINDOW_SIZE * pixelRatio}x${size * pixelRatio}`;

  Byond.winset(null, {
    'tgui_say.size': sizeStr,
    'tgui_say.browser.size': sizeStr,
  });
}

/** Helper function to set window size and visibility */
function setWindowVisibility(visible: boolean, scale: boolean): void {
  const pixelRatio = scale ? window.devicePixelRatio : 1;

  const sizeStr = `${WIDTH_WINDOW_SIZE * pixelRatio}x${SMALL_WINDOW_SIZE * pixelRatio}`;

  Byond.winset(null, {
    'tgui_say.is-visible': visible,
    'tgui_say.size': sizeStr,
    'tgui_say.browser.size': sizeStr,
  });
}

export const isHuman = (type: LivingType) => type === LIVING_TYPES.HUMAN;
export const isXeno = (type: LivingType) => type === LIVING_TYPES.XENO;
export const isSynth = (type: LivingType) => type === LIVING_TYPES.SYNTH;
export const isYautja = (type: LivingType) => type === LIVING_TYPES.YAUTJA;

const CHANNEL_REGEX = /^[:.#№][\wА-яёЁ]\s/;

function normalizeRadioPrefixes(input: string): string {
  return RADIO_PREFIXES_MAP[input] ?? input;
}

/** Tests for a channel prefix, returning it or none */
export function getPrefix(value: string): keyof typeof RADIO_PREFIXES | null {
  if (!value || value.length < 3 || !CHANNEL_REGEX.test(value)) {
    return null;
  }

  const adjusted = normalizeRadioPrefixes(
    value
      .slice(0, 3)
      ?.toLowerCase()
      ?.replace('.', ':')
      ?.replace('#', ':')
      ?.replace('№', ':'),
  ) as keyof typeof RADIO_PREFIXES;

  if (!RADIO_PREFIXES[adjusted]) {
    return null;
  }

  return adjusted;
}
