import { Modal } from '../types';

/**
 * 1. Resets history if editing a message
 * 2. Backspacing while empty resets any radio subchannels
 * 3. Ensures backspace and delete calculate window size
 */
export const handleBackspaceDelete = function (this: Modal) {
  const { buttonContent, channel } = this.state;
  const { radioPrefix, value, availableChannels } = this.fields;

  // User is on a chat history message
  if (typeof buttonContent === 'number') {
    this.fields.historyCounter = 0;
    this.setState({ buttonContent: availableChannels[channel] });
  }
  if (!value?.length && radioPrefix) {
    this.fields.radioPrefix = '';
    this.setState({ buttonContent: availableChannels[channel] });
  }
  this.events.onSetSize(value?.length);
};
