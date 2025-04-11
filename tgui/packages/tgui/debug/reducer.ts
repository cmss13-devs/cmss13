/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import type { ActionData } from './types';

type StateData = { kitchenSink: boolean; debugLayout: boolean };

export const debugReducer = (state = {} as StateData, action: ActionData) => {
  const { type, payload } = action;
  if (type === 'debug/toggleKitchenSink') {
    return {
      ...state,
      kitchenSink: !state.kitchenSink,
    };
  }
  if (type === 'debug/toggleDebugLayout') {
    return {
      ...state,
      debugLayout: !state.debugLayout,
    };
  }
  return state;
};
