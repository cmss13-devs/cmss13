/**
 * ### Key codes.
 * event.keyCode is deprecated, use this reference instead.
 *
 * Handles modifier keys (Shift, Alt, Control) and arrow keys.
 *
 * For alphabetical keys, use the actual character (e.g. 'a') instead of the key code.
 * Don't access Esc or Escape directly, use isEscape() instead
 *
 * Something isn't here that you want? Just add it:
 * @url https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values
 * @usage
 * ```ts
 * import { KEY } from 'tgui/common/keys';
 *
 * if (event.key === KEY.Enter) {
 *   // do something
 * }
 * ```
 *
 *
 */
export enum KEY {
  A = 'a',
  Alt = 'Alt',
  Backspace = 'Backspace',
  Control = 'Control',
  D = 'd',
  Delete = 'Delete',
  Down = 'ArrowDown',
  E = 'e',
  End = 'End',
  Enter = 'Enter',
  Esc = 'Esc',
  Escape = 'Escape',
  Home = 'Home',
  Insert = 'Insert',
  Left = 'ArrowLeft',
  N = 'n',
  PageDown = 'PageDown',
  PageUp = 'PageUp',
  Right = 'ArrowRight',
  S = 's',
  Shift = 'Shift',
  Space = ' ',
  Tab = 'Tab',
  Up = 'ArrowUp',
  W = 'w',
  Z = 'z',
}

/**
 * ### isEscape
 *
 * Checks if the user has hit the 'ESC' key on their keyboard.
 * There's a weirdness in BYOND where this could be either the string
 * 'Escape' or 'Esc' depending on the browser. This function handles
 * both cases.
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key is Escape or Esc, false otherwise
 */
export function isEscape(key: string): boolean {
  return key === KEY.Esc || key === KEY.Escape;
}

/**
 * ### isAlphabetic
 *
 * Checks if the user has hit any alphabetic key (a - z)
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key is in the range of a-z
 */
export function isAlphabetic(key: string): boolean {
  return key >= KEY.A && key <= KEY.Z;
}

/**
 * ### isNumeric
 *
 * Checks if the user has hit any numeric key (0 - 9)
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key is in the range of 0 - 9
 */
export function isNumeric(key: string): boolean {
  return key >= '0' && key <= '9';
}

/**
 * ### isCardinal
 *
 * Checks if the user has hit any cardinal key (n s w e)
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key matches any cardinal n s w e
 */
export function isCardinal(key: string): boolean {
  return key === KEY.N || key === KEY.S || key === KEY.W || key === KEY.E;
}

/**
 * ### isArrow
 *
 * Checks if the user has hit any arrow key
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key matches any arrow keys
 */
export function isArrow(key: string): boolean {
  return (
    key === KEY.Up || key === KEY.Down || key === KEY.Left || key === KEY.Right
  );
}

/**
 * ### isWasd
 *
 * Checks if the user has hit any w a s d key
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key matches any w a s d
 */
export function isWasd(key: string): boolean {
  return key === KEY.W || key === KEY.A || key === KEY.S || key === KEY.D;
}

/**
 * ### isMovement
 *
 * Checks if the user has hit any movement key (w a s d and arrow keys)
 *
 * @param key - the key to check, typically from event.key
 * @returns true if key matches any movement key w a s d and arrow keys
 */
export function isMovement(key: string): boolean {
  return isWasd(key) || isArrow(key);
}
