/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { selectGame } from '../game/selectors';
import { AudioPlayer } from './player';

export const audioMiddleware = (store) => {
  const player = new AudioPlayer();
  player.onPlay(() => {
    store.dispatch({ type: 'audio/playing' });
  });
  player.onStop(() => {
    store.dispatch({ type: 'audio/stopped' });
  });
  return (next) => (action) => {
    const { type, payload } = action;
    if (type === 'audio/playMusic') {
      const state = store.getState();
      if (state) {
        const game = selectGame(state);
        if (game.tvMode) {
          return next(action);
        }
      }

      const { url, ...options } = payload;
      player.play(url, options);
      return next(action);
    }
    if (type === 'audio/stopMusic') {
      player.stop();
      return next(action);
    }
    if (type === 'settings/update' || type === 'settings/load') {
      const volume = payload?.adminMusicVolume;
      if (typeof volume === 'number') {
        player.setVolume(volume);
      }
      return next(action);
    }
    return next(action);
  };
};
