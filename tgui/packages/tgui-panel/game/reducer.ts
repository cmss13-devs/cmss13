/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { chatRenderer } from '../chat/renderer';
import { connectionLost, tvMode } from './actions';
import { connectionRestored } from './actions';

const initialState = {
  // TODO: This is where round info should be.
  roundId: null,
  roundTime: null,
  roundRestartedAt: null,
  connectionLostAt: null,
  tvMode: false,
};

export const gameReducer = (state = initialState, action) => {
  const { type, meta } = action;
  if (type === 'roundrestart') {
    return {
      ...state,
      roundRestartedAt: meta.now,
    };
  }
  if (type === connectionLost.type) {
    return {
      ...state,
      connectionLostAt: meta.now,
    };
  }
  if (type === connectionRestored.type) {
    return {
      ...state,
      connectionLostAt: null,
    };
  }
  if (type === tvMode.type) {
    chatRenderer.alwaysStayAtBottom = true;

    Byond.winset(null, { 'split.right': 'output_browser' });

    return {
      ...state,
      tvMode: true,
    };
  }
  return state;
};
