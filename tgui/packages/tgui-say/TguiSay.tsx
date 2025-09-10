import './styles/main.scss';

import { isEscape, KEY } from 'common/keys';
import { type BooleanLike, classes } from 'common/react';
import { useEffect, useRef, useState } from 'react';
import { dragStartHandler } from 'tgui/drag';

import { type Channel, ChannelIterator, CHANNELS } from './ChannelIterator';
import { ChatHistory } from './ChatHistory';
import {
  LARGE_WINDOW_SIZE,
  LIVING_TYPES,
  type LivingType,
  MEDIUM_LINE_SIZE,
  MEDIUM_WINDOW_SIZE,
  RADIO_PREFIXES,
  SMALL_LINE_SIZE,
  SMALL_WINDOW_SIZE,
} from './constants';
import { getPrefix, windowClose, windowOpen, windowSet } from './helpers';
import { byondMessages } from './timers';

type ByondOpenType = {
  channel: Channel;
};

type AvailableChannels = Record<string, number>;

type ByondPropsType = {
  maxLength: number;
  lightMode: BooleanLike;
  scale: BooleanLike;
};

type ByondUpdateChannelsType = {
  availableChannels: AvailableChannels;
  livingType: LivingType;
};

type RadioPrefixType = keyof typeof RADIO_PREFIXES;

export function TguiSay() {
  const [livingType, setLivingType] = useState<LivingType>(LIVING_TYPES.HUMAN);
  const innerRef = useRef<HTMLTextAreaElement>(null);
  const channelIterator = useRef(new ChannelIterator(livingType));
  const chatHistory = useRef(new ChatHistory());
  const messages = useRef(byondMessages);
  const scale = useRef(true);

  // I initially wanted to make these an object or a reducer, but it's not really worth it.
  // You lose the granulatity and add a lot of boilerplate.
  const [buttonContent, setButtonContent] = useState('');
  const [currentPrefix, setCurrentPrefix] = useState<RadioPrefixType | null>(
    null,
  );
  const [lightMode, setLightMode] = useState(false);
  const [maxLength, setMaxLength] = useState(1024);
  const [size, setSize] = useState(SMALL_WINDOW_SIZE);
  const [value, setValue] = useState('');
  const [availableChannels, setAvailableChannels] = useState<AvailableChannels>(
    {},
  );

  const position = useRef([window.screenX, window.screenY]);
  const isDragging = useRef(false);
  const translateChannelLabel = channelIterator.current.translate();
  const theme = currentPrefix
    ? RADIO_PREFIXES[currentPrefix].label
    : translateChannelLabel;

  function handleArrowKeys(direction: KEY.Up | KEY.Down): void {
    const chat = chatHistory.current;

    if (direction === KEY.Up) {
      if (chat.isAtLatest() && value) {
        // Save current message to temp history if at the most recent message
        chat.saveTemp(value);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = chat.getOlderMessage();

      if (prevMessage) {
        setButtonContent(chat.getIndex().toString());
        setValue(prevMessage);
      }
    } else {
      const nextMessage = chat.getNewerMessage() || chat.getTemp() || '';

      const newContent = chat.isAtLatest()
        ? channelIterator.current.translate()
        : chat.getIndex().toString();

      setButtonContent(newContent);
      setValue(nextMessage);
    }
  }

  function handleBackspaceDelete(): void {
    const chat = chatHistory.current;

    // User is on a chat history message
    if (!chat.isAtLatest()) {
      chat.reset();
      setButtonContent(currentPrefix ?? channelIterator.current.translate());

      // Empty input, resets the channel
    } else if (
      currentPrefix &&
      channelIterator.current.isSay() &&
      value?.length === 0
    ) {
      setCurrentPrefix(null);
      setButtonContent(channelIterator.current.translate());
    }
  }

  function handleButtonClick(event: React.MouseEvent<HTMLButtonElement>): void {
    isDragging.current = true;

    setTimeout(() => {
      // So the button doesn't jump around accidentally
      if (isDragging.current) {
        dragStartHandler(event.nativeEvent);
      }
    }, 50);
  }

  // Prevents the button from changing channels if it's dragged
  function handleButtonRelease(): void {
    isDragging.current = false;
    const currentPosition = [window.screenX, window.screenY];

    if (JSON.stringify(position.current) !== JSON.stringify(currentPosition)) {
      position.current = currentPosition;
      return;
    }

    handleIncrementChannel();
  }

  function handleClose(): void {
    innerRef.current?.blur();
    windowClose(scale.current);

    setTimeout(() => {
      chatHistory.current.reset();
      channelIterator.current.reset();
      unloadChat();
    }, 25);
  }

  function handleEnter(): void {
    const iterator = channelIterator.current;
    const prefix = currentPrefix ?? '';

    if (value?.length && value.length < maxLength) {
      chatHistory.current.add(value);
      Byond.sendMessage('entry', {
        channel: iterator.current(),
        entry: iterator.isSay() ? prefix + value : value,
      });
    }

    handleClose();
  }

  function handleForceSay(): void {
    const iterator = channelIterator.current;

    // Only force say if we're on a visible channel and have typed something
    if (!value || iterator.isVisible()) {
      return;
    }

    const prefix = currentPrefix ?? '';
    const grunt = iterator.isSay() ? prefix + value : value;

    messages.current.forceSayMsg(grunt, iterator.current());
    unloadChat();
  }

  function handleIncrementChannel(): void {
    setButtonContent(channelIterator.current.getNextTranslated());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(channelIterator.current.isVisible());
  }

  function handleInput(event: React.FormEvent<HTMLTextAreaElement>): void {
    const iterator = channelIterator.current;
    let newValue = event.currentTarget.value;

    const newPrefix = getPrefix(newValue) ?? currentPrefix;
    if (canChangePrefix(newPrefix)) {
      setButtonContent(RADIO_PREFIXES[newPrefix as RadioPrefixType].label);
      setCurrentPrefix(newPrefix);
      newValue = newValue.slice(3);
      iterator.set(CHANNELS.SAY);
    }

    // Handles typing indicators
    if (channelIterator.current.isVisible()) {
      messages.current.typingMsg();
    }

    setValue(newValue);
  }

  function canChangePrefix(newPrefix: string | null): boolean {
    if (newPrefix === currentPrefix) {
      return false;
    }

    const channelId = RADIO_PREFIXES[newPrefix as RadioPrefixType]?.id ?? null;
    if (channelId === null) {
      return true;
    }

    return Object.keys(availableChannels).includes(channelId);
  }

  function handleKeyDown(
    event: React.KeyboardEvent<HTMLTextAreaElement>,
  ): void {
    if (event.getModifierState('AltGraph')) {
      return;
    }

    switch (event.key) {
      case KEY.Up:
      case KEY.Down:
        event.preventDefault();
        handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        handleBackspaceDelete();
        break;

      case KEY.Enter:
        event.preventDefault();
        handleEnter();
        break;

      case KEY.Tab:
        event.preventDefault();
        handleIncrementChannel();
        break;

      default:
        if (isEscape(event.key)) {
          handleClose();
        }
    }
  }

  function handleOpen(data: ByondOpenType): void {
    channelIterator.current.set(data.channel);
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.translate());
    windowOpen(channelIterator.current.current(), scale.current);
    innerRef.current?.focus();
  }

  function handleProps(data: ByondPropsType): void {
    setMaxLength(data.maxLength);
    setLightMode(!!data.lightMode);
    scale.current = !!data.scale;
  }

  function handleUpdateChannels(data: ByondUpdateChannelsType): void {
    setAvailableChannels(
      typeof data.availableChannels === 'object' ? data.availableChannels : {},
    );
    setLivingType(data.livingType);
  }

  function unloadChat(): void {
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.translate());
    setValue('');
  }

  /** Subscribe to Byond messages */
  useEffect(() => {
    Byond.subscribeTo('props', handleProps);
    Byond.subscribeTo('force', handleForceSay);
    Byond.subscribeTo('open', handleOpen);
    Byond.subscribeTo('update_channels', handleUpdateChannels);
  }, []);

  /** Value has changed, we need to check if the size of the window is ok */
  useEffect(() => {
    const newSize =
      value?.length > MEDIUM_LINE_SIZE
        ? LARGE_WINDOW_SIZE
        : value?.length > SMALL_LINE_SIZE
          ? MEDIUM_WINDOW_SIZE
          : SMALL_WINDOW_SIZE;

    if (size !== newSize) {
      windowSet(newSize, scale.current);
      setSize(newSize);
    }
  }, [value]);

  useEffect(() => {
    channelIterator.current = new ChannelIterator(livingType);
    setButtonContent(channelIterator.current.translate());
  }, [livingType]);

  return (
    <div
      className={classes([
        'window',
        `window-${theme}`,
        lightMode && 'window-light',
      ])}
      style={{
        zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
      }}
    >
      <div className="content">
        <button
          className="button"
          onMouseDown={handleButtonClick}
          onMouseUp={handleButtonRelease}
          type="button"
        >
          {buttonContent}
        </button>
        <textarea
          autoCorrect="off"
          className="textarea"
          maxLength={maxLength}
          onInput={handleInput}
          onKeyDown={handleKeyDown}
          ref={innerRef}
          spellCheck={false}
          value={value}
        />
      </div>
    </div>
  );
}
