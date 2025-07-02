/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import type { AudioState } from './types';

const initialState: AudioState = {
  visible: false,
  playing: false,
  track: null,
};

export const audioReducer = (state = initialState, action) => {
  const { type, payload } = action;
  if (type === 'audio/playing') {
    return {
      ...state,
      visible: true,
      playing: true,
    };
  }
  if (type === 'audio/stopped') {
    return {
      ...state,
      visible: false,
      playing: false,
    };
  }
  if (type === 'audio/playMusic') {
    return {
      ...state,
      meta: payload,
    };
  }
  if (type === 'audio/stopMusic') {
    return {
      ...state,
      visible: false,
      playing: false,
      meta: null,
    };
  }
  if (type === 'audio/toggle') {
    return {
      ...state,
      visible: !state.visible,
    };
  }
  return state;
};
