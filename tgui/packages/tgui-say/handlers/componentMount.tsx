import { getAvailableChannels, windowLoad, windowOpen } from '../helpers';
import { Modal } from '../types';

/** Attach listeners, sets window size just in case */
export const handleComponentMount = function (this: Modal) {
  Byond.subscribeTo('props', (data) => {
    this.fields.maxLength = data.maxLength;
    this.fields.lightMode = !!data.lightMode;
    this.fields.availableChannels = getAvailableChannels(data.roles);
  });
  Byond.subscribeTo('force', () => {
    this.events.onForce();
  });
  Byond.subscribeTo('open', (data) => {
    const channel = this.fields.availableChannels.indexOf(data.channel) || 0;

    this.setState({
      buttonContent: this.fields.availableChannels[channel],
      channel,
    });
    setTimeout(() => {
      this.fields.innerRef.current?.focus();
    }, 1);
    windowOpen(this.fields.availableChannels[channel]);
  });
  windowLoad();
};
