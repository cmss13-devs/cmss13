import { ADMIN_CHANNELS, CHANNELS } from '../constants';
import { windowLoad, windowOpen } from '../helpers';
import { Modal } from '../types';

/** Attach listeners, sets window size just in case */
export const handleComponentMount = function (this: Modal) {
  Byond.subscribeTo('props', (data) => {
    this.fields.maxLength = data.maxLength;
    this.fields.lightMode = !!data.lightMode;
    this.fields.admin = !!data.admin;
  });
  Byond.subscribeTo('force', () => {
    this.events.onForce();
  });
  Byond.subscribeTo('open', (data) => {
    const usedChannels = this.fields.admin ? ADMIN_CHANNELS : CHANNELS;
    const channel = usedChannels.indexOf(data.channel) || 0;

    this.setState({ buttonContent: usedChannels[channel], channel });
    setTimeout(() => {
      this.fields.innerRef.current?.focus();
    }, 1);
    windowOpen(usedChannels[channel]);
  });
  windowLoad();
};
