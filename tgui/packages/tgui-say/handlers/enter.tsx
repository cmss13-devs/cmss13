import { storeChat, windowClose } from '../helpers';
import { Modal } from '../types';

/** User presses enter. Closes if no value. */
export const handleEnter = function (
  this: Modal,
  event: KeyboardEvent,
  value: string
) {
  const { channel } = this.state;
  const { maxLength, radioPrefix, availableChannels } = this.fields;

  event.preventDefault();
  if (value && value.length < maxLength) {
    storeChat(value);
    Byond.sendMessage('entry', {
      channel: availableChannels[channel],
      entry: channel === 0 ? radioPrefix + value : value,
    });
  }
  this.events.onReset();
  windowClose();
};
