import { LIVING_TYPES, type LivingType } from './constants';

export type Channel = (typeof CHANNELS)[keyof typeof CHANNELS];

export const CHANNELS = {
  SAY: 'Say',
  COMMS: 'Comms',
  WHISPER: 'Whisper',
  ME: 'Me',
  OOC: 'OOC',
  LOOC: 'LOOC',
  MENTOR: 'Mentor',
  ASAY: 'ASAY',
} as const;

export const DEFAULT_BLACKLIST: Channel[] = [CHANNELS.MENTOR, CHANNELS.ASAY];
export const QUIET_CHANNELS: Channel[] = [
  CHANNELS.OOC,
  CHANNELS.LOOC,
  ...DEFAULT_BLACKLIST,
];

/**
 * Cycles a predefined list of channels,
 * skipping over blacklisted ones,
 * and providing methods to manage and query the current channel.
 */
export class ChannelIterator {
  private index: number = 0;
  private readonly channels: Channel[] = Object.values(CHANNELS);
  private readonly blacklist: Channel[];
  private readonly livingType: LivingType;

  constructor(livingType: LivingType = LIVING_TYPES.HUMAN) {
    this.blacklist = [
      ...DEFAULT_BLACKLIST,
      ...(livingType === LIVING_TYPES.XENO ? [CHANNELS.WHISPER] : []),
    ];
    this.livingType = livingType;
  }

  public next(): Channel {
    if (this.blacklist.includes(this.channels[this.index])) {
      return this.channels[this.index];
    }

    do {
      this.index = (this.index + 1) % this.channels.length;
    } while (this.blacklist.includes(this.current()));

    return this.current();
  }

  public set(channel: Channel): void {
    this.index = this.channels.indexOf(channel) || 0;
  }

  public current(): Channel {
    return this.channels[this.index];
  }

  public isSay(): boolean {
    return this.current() === CHANNELS.SAY;
  }

  public isVisible(): boolean {
    return !QUIET_CHANNELS.includes(this.current());
  }

  public reset(): void {
    this.index = 0;
  }

  public getNextTranslated(): string {
    this.next();
    return this.translate();
  }

  private getCommsName() {
    switch (this.livingType) {
      case LIVING_TYPES.XENO:
        return 'Улей';
      case LIVING_TYPES.YAUTJA:
        return 'Хищники';
      default:
        return 'Рация';
    }
  }

  private getTranslations(): Record<Channel, string> {
    return {
      [CHANNELS.SAY]: 'Говорить',
      [CHANNELS.COMMS]: this.getCommsName(),
      [CHANNELS.ME]: 'Эмоция',
      [CHANNELS.WHISPER]: 'Шёпот',
      [CHANNELS.OOC]: 'OOC',
      [CHANNELS.LOOC]: 'LOOC',
      [CHANNELS.MENTOR]: 'Ментор',
      [CHANNELS.ASAY]: 'Админ',
    };
  }

  public translate(): string {
    return this.getTranslations()[this.current()];
  }
}
