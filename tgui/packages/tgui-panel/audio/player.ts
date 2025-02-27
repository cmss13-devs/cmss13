/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from 'tgui/logging';

const logger = createLogger('AudioPlayer');

export class TridentAudioPlayer implements AudioPlayer {
  node: HTMLAudioElement;
  playing: boolean;
  volume: number;
  options: AudioOptions;
  onPlaySubscribers: { (): void }[];
  onStopSubscribers: { (): void }[];
  playbackInterval: NodeJS.Timeout;

  constructor() {
    // Set up the HTMLAudioElement node
    this.node = document.createElement('audio');
    this.node.style.setProperty('display', 'none');
    document.body.appendChild(this.node);
    // Set up other properties
    this.playing = false;
    this.volume = 1;
    this.options = {};
    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
    // Listen for playback start events
    this.node.addEventListener('canplaythrough', () => {
      logger.log('canplaythrough');
      this.playing = true;
      this.node.playbackRate = this.options.pitch || 1;
      this.node.currentTime = this.options.start || 0;
      this.node.volume = this.volume;
      this.node.play();
      for (let subscriber of this.onPlaySubscribers) {
        subscriber();
      }
    });
    // Listen for playback stop events
    this.node.addEventListener('ended', () => {
      logger.log('ended');
      this.stop();
    });
    // Listen for playback errors
    this.node.addEventListener('error', (e) => {
      if (this.playing) {
        logger.log('playback error', e.error);
        this.stop();
      }
    });
    // Check every second to stop the playback at the right time
    this.playbackInterval = setInterval(() => {
      if (!this.playing) {
        return;
      }
      const shouldStop =
        this.options.end &&
        this.options.end > 0 &&
        this.node.currentTime >= this.options.end;
      if (shouldStop) {
        this.stop();
      }
    }, 1000);
  }

  destroy() {
    if (!this.node) {
      return;
    }
    document.removeChild(this.node);
    clearInterval(this.playbackInterval);
  }

  play(url, options = {}) {
    if (!this.node) {
      return;
    }
    logger.log('playing', url, options);
    this.options = options;
    this.node.src = url;
  }

  stop() {
    if (!this.node) {
      return;
    }
    if (this.playing) {
      for (let subscriber of this.onStopSubscribers) {
        subscriber();
      }
    }
    logger.log('stopping');
    this.playing = false;
    this.node.src = '';
  }

  setVolume(volume: number) {
    if (!this.node) {
      return;
    }
    this.volume = volume;
    this.node.volume = volume;
  }

  onPlay(subscriber: () => {}) {
    if (!this.node) {
      return;
    }
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber: () => {}) {
    if (!this.node) {
      return;
    }
    this.onStopSubscribers.push(subscriber);
  }
}

export class WebviewAudioPlayer implements AudioPlayer {
  element: HTMLAudioElement | null;
  options: AudioOptions;
  volume: number;

  onPlaySubscribers: { (): void }[];
  onStopSubscribers: { (): void }[];

  constructor() {
    this.element = null;

    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
  }

  destroy() {
    this.element = null;
  }

  play(url: string, options = {}) {
    this.options = options;

    const audio = (this.element = new Audio(url));
    audio.volume = this.volume;
    audio.playbackRate = this.options.pitch || 1;

    audio.addEventListener('ended', () => this.stop());
    audio.addEventListener('error', () => this.stop());

    if (this.options.end) {
      audio.addEventListener('timeupdate', () => {
        if (
          this.options.end &&
          this.options.end > 0 &&
          audio.currentTime >= this.options.end
        ) {
          this.stop();
        }
      });
    }

    audio.play();

    this.onPlaySubscribers.forEach((subscriber) => subscriber());
  }

  stop() {
    if (!this.element) return;

    this.element.pause();
    this.element = null;

    this.onStopSubscribers.forEach((subscriber) => subscriber());
  }

  setVolume(volume: number): void {
    this.volume = volume;

    if (!this.element) return;

    this.element.volume = volume;
  }

  onPlay(subscriber: () => {}): void {
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber: () => {}): void {
    this.onStopSubscribers.push(subscriber);
  }
}

type AudioOptions = {
  pitch?: number;
  start?: number;
  end?: number;
};

interface AudioPlayer {
  destroy(): void;
  play(url: string, options: AudioOptions): void;
  stop(): void;
  setVolume(volume: number): void;
  onPlay(subscriber: () => {}): void;
  onStop(subscriber: () => {}): void;
}
