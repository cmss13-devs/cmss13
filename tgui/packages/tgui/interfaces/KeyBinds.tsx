import type { Placement } from '@popperjs/core';
import { Component, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  Input,
  Section,
} from 'tgui/components';
import { globalEvents } from 'tgui/events';
import { Window } from 'tgui/layouts';

import { replaceRegexChars } from './helpers';
import type { ButtonProps } from './MfdPanels/types';

const KEY_MODS = {
  SHIFT: true,
  ALT: true,
  CONTROL: true,
};

const KEY_CODE_TO_BYOND = {
  DEL: 'Delete',
  DOWN: 'South',
  END: 'Southwest',
  HOME: 'Northwest',
  INSERT: 'Insert',
  LEFT: 'West',
  PAGEDOWN: 'Southeast',
  PAGEUP: 'Northeast',
  RIGHT: 'East',
  ' ': 'Space',
  UP: 'North',
};

const getAllKeybinds = (glob_keybinds) => {
  const all_keybinds = new Array();
  Object.keys(glob_keybinds).map((x) => all_keybinds.push(...glob_keybinds[x]));
  return all_keybinds;
};

type Keybind = {
  name: string;
  full_name: string;
  hotkey_keys: string[];
  classic: string[];
};

type Data = {
  player_keybinds: Record<string, string>;
  custom_keybinds: (null | CustomKeybind)[];
  glob_keybinds: Record<string, Keybind[]>;
  byond_keymap: Record<string, string>;
};

type CustomKeybind = {
  keybinding?: string;
  type?: string;
  contents?: string | string[];
  when_xeno?: boolean;
  when_human?: boolean;
};

export const KeyBinds = (props) => {
  const { act, data } = useBackend<Data>();
  const { player_keybinds, glob_keybinds, byond_keymap, custom_keybinds } =
    data;

  const [selectedTab, setSelectedTab] = useState('ALL');
  const [searchTerm, setSearchTerm] = useState('');

  const keybinds_to_use =
    searchTerm.length || selectedTab === 'ALL'
      ? getAllKeybinds(glob_keybinds)
      : glob_keybinds[selectedTab];

  const filteredKeybinds =
    selectedTab !== 'CUSTOM' &&
    keybinds_to_use.filter(
      (val) =>
        !searchTerm ||
        val.full_name.toLowerCase().match(replaceRegexChars(searchTerm)),
    );

  const filteredCustomKeybinds = custom_keybinds
    .map((keybind, index) => ({ keybind, index }))
    .filter(({ keybind }) => {
      if (!searchTerm) return true;
      if (!keybind?.contents) return false;
      const contents =
        typeof keybind.contents === 'object'
          ? keybind.contents.join(' ')
          : keybind.contents;
      return contents.toLowerCase().match(replaceRegexChars(searchTerm));
    });

  return (
    <Window width={400} height={500}>
      <Window.Content scrollable>
        <Flex direction="column">
          <Flex.Item>
            <Section
              title="Settings"
              buttons={
                <Flex.Item>
                  <Button
                    color="red"
                    icon="undo"
                    onClick={() => act('clear_all_keybinds')}
                  >
                    Reset to Default
                  </Button>
                </Flex.Item>
              }
            >
              <Flex direction="column">
                <Flex.Item>
                  <Flex align="baseline" mt="5px">
                    <Flex.Item grow>
                      <Input
                        value={searchTerm}
                        onInput={(_, value) =>
                          setSearchTerm(value.toLowerCase())
                        }
                        placeholder="Search..."
                        fluid
                      />
                    </Flex.Item>
                    <Flex.Item>
                      <ButtonKeybind
                        tooltip="Search by key"
                        tooltipPosition="bottom-start"
                        icon="keyboard"
                        onFinish={(keysDown) => {
                          // The key(s) pressed by the user, byond-ified.
                          const targetKey = keysDown
                            .map((k) => byond_keymap[k] || k)
                            .join('+');
                          // targetKey's entry in player_keybinds.
                          const targetEntry = player_keybinds[targetKey];
                          // Check regular keybinds first
                          if (targetEntry) {
                            // If a keybind was found, scroll to the first match currently rendered.
                            for (let i = 0; i < targetEntry.length; i++) {
                              const element = document.getElementById(
                                targetEntry[i],
                              );
                              if (element) {
                                element.scrollIntoView();
                                return;
                              }
                            }
                          }
                          // Check custom keybinds
                          for (let i = 0; i < custom_keybinds.length; i++) {
                            const customKeybind = custom_keybinds[i];
                            if (customKeybind?.keybinding === targetKey) {
                              const element = document.getElementById(
                                `custom-keybind-${i}`,
                              );
                              if (element) {
                                element.scrollIntoView();
                                return;
                              }
                            }
                          }
                        }}
                      />
                    </Flex.Item>
                  </Flex>
                </Flex.Item>
                <Flex.Item>
                  <Box height="5px" />
                  <KeybindsDropdown
                    selectedTab={selectedTab}
                    setSelectedTab={setSelectedTab}
                    searchTerm={searchTerm}
                  />
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
          <Flex direction="column">
            {(selectedTab === 'CUSTOM' || searchTerm.length > 0) &&
              filteredCustomKeybinds.length > 0 && (
                <Section title="Custom Keybinds">
                  {filteredCustomKeybinds.map(({ keybind, index }) => (
                    <CustomKeybinds
                      keybind={keybind}
                      index={index}
                      key={`kb${index}`}
                    />
                  ))}
                </Section>
              )}
            {selectedTab !== 'CUSTOM' &&
              (selectedTab === 'ALL' && !searchTerm.length
                ? Object.keys(glob_keybinds).map((category) => (
                    <Flex.Item key={category}>
                      <Section title={category}>
                        <Flex direction="column">
                          {glob_keybinds[category].map((keybind) => (
                            <Flex.Item key={keybind}>
                              <KeybindElement keybind={keybind} />
                              <Box
                                backgroundColor="rgba(40, 40, 40, 255)"
                                width="100%"
                                height="2px"
                                mt="2px"
                              />
                            </Flex.Item>
                          ))}
                        </Flex>
                      </Section>
                    </Flex.Item>
                  ))
                : filteredKeybinds &&
                  filteredKeybinds.map((keybind) => (
                    <Flex.Item key={keybind.full_name}>
                      <KeybindElement keybind={keybind} />
                      <Box
                        backgroundColor="rgba(40, 40, 40, 255)"
                        width="100%"
                        height="2px"
                        mt="2px"
                      />
                    </Flex.Item>
                  )))}
          </Flex>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const CustomKeybinds = (props: {
  readonly keybind: CustomKeybind | null;
  readonly index: number;
}) => {
  const { index, keybind } = props;

  const { act } = useBackend();

  const [pendingKeybind, setPendingKeybind] = useState<CustomKeybind>();
  const [isEditingContents, setIsEditingContents] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [picksayOptions, setPicksayOptions] = useState<string[]>([]);

  const currentType = pendingKeybind?.type || keybind?.type;
  const isPicksay = currentType === 'PICKSAY';

  const handleStartEditing = () => {
    setIsEditingContents(true);

    const currentContents = pendingKeybind?.contents ?? keybind?.contents;

    if (isPicksay) {
      if (currentContents) {
        setPicksayOptions(
          typeof currentContents === 'object'
            ? [...currentContents]
            : [currentContents],
        );
      } else {
        setPicksayOptions([]);
      }
      setInputValue('');
    } else {
      setInputValue(
        currentContents
          ? typeof currentContents === 'object'
            ? currentContents[0] || ''
            : currentContents
          : '',
      );
      setPicksayOptions([]);
    }
  };

  const handleAddPicksayOption = () => {
    if (inputValue.trim() && picksayOptions.length < 20) {
      setPicksayOptions((prev) => [...prev, inputValue.trim()]);
      setInputValue('');
    }
  };

  const handleRemovePicksayOption = (idx: number) => {
    setPicksayOptions((prev) => prev.filter((_, i) => i !== idx));
  };

  const handleConfirmContents = () => {
    const newContents = isPicksay ? picksayOptions : inputValue.trim();
    if (isPicksay ? picksayOptions.length > 0 : inputValue.trim()) {
      setPendingKeybind((pending) => ({
        ...(pending || keybind),
        contents: newContents,
      }));
    }
    setIsEditingContents(false);
    setInputValue('');
  };

  const handleCancelEditing = () => {
    setIsEditingContents(false);
    setInputValue('');
    setPicksayOptions([]);
  };

  if (isEditingContents) {
    return (
      <Flex.Item key={`idx${index}`} id={`custom-keybind-${index}`}>
        <Flex direction="column">
          <Flex.Item>
            <Box fontSize="115%" color="label" mb={1}>
              Custom Keybind {index + 1} - Set{' '}
              {isPicksay ? 'Options' : 'Content'}
            </Box>
          </Flex.Item>
          {isPicksay ? (
            <>
              <Flex.Item mb={1}>
                <Flex align="center">
                  <Flex.Item grow>
                    <Input
                      fluid
                      placeholder="Add an option..."
                      maxLength={1024}
                      value={inputValue}
                      onInput={(_, val) => setInputValue(val)}
                      onEnter={() => handleAddPicksayOption()}
                    />
                  </Flex.Item>
                  <Flex.Item ml={1}>
                    <Button
                      icon="plus"
                      disabled={picksayOptions.length >= 20}
                      onClick={() => handleAddPicksayOption()}
                    >
                      Add
                    </Button>
                  </Flex.Item>
                </Flex>
              </Flex.Item>
              {picksayOptions.length > 0 && (
                <Flex.Item mb={1}>
                  <Box>
                    {picksayOptions.map((option, idx) => (
                      <Box key={idx} inline mr={1} mb={0.5}>
                        <Button
                          icon="times"
                          color="transparent"
                          onClick={() => handleRemovePicksayOption(idx)}
                        >
                          {option}
                        </Button>
                      </Box>
                    ))}
                  </Box>
                </Flex.Item>
              )}
            </>
          ) : (
            <Flex.Item mb={1}>
              <Input
                fluid
                maxLength={1024}
                placeholder="Enter content..."
                value={inputValue}
                onInput={(_, val) => setInputValue(val)}
                onEnter={() => handleConfirmContents()}
              />
            </Flex.Item>
          )}
          <Flex.Item>
            <Flex>
              <Flex.Item>
                <Button color="good" onClick={() => handleConfirmContents()}>
                  Confirm
                </Button>
              </Flex.Item>
              <Flex.Item ml={1}>
                <Button color="bad" onClick={() => handleCancelEditing()}>
                  Cancel
                </Button>
              </Flex.Item>
            </Flex>
          </Flex.Item>
        </Flex>
        <Divider />
      </Flex.Item>
    );
  }

  const displayContents = pendingKeybind?.contents ?? keybind?.contents;
  const displayText = displayContents
    ? typeof displayContents === 'object'
      ? displayContents.join(', ')
      : displayContents
    : 'Unset';

  return (
    <Flex.Item key={`idx${index}`} id={`custom-keybind-${index}`}>
      <Flex align="center">
        <Flex.Item basis="10%" shrink={0}>
          <Box fontSize="115%" color="label">
            {index + 1}
          </Box>
        </Flex.Item>
        <Flex.Item grow shrink basis={0}>
          <Flex align="center" nowrap>
            <Flex.Item grow shrink basis={0}>
              <Box
                nowrap
                color={displayContents ? 'default' : 'label'}
                style={{
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                  maxWidth: '100px',
                }}
              >
                {displayText}
              </Box>
            </Flex.Item>
            <Flex.Item shrink={0} ml={1}>
              <Button
                className="Button--dropdown"
                onClick={() => handleStartEditing()}
              >
                Set
              </Button>
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item>
          <Dropdown
            placeholder="Type"
            options={['SAY', 'ME', 'PICKSAY']}
            selected={
              pendingKeybind?.type?.toUpperCase() ||
              keybind?.type?.toUpperCase()
            }
            onSelected={(selected) => {
              setPendingKeybind((pending) => {
                if (!pending) {
                  return {
                    ...keybind,
                    type: selected,
                  };
                }

                return {
                  ...pending,
                  type: selected,
                };
              });
            }}
            width="85px"
            menuWidth="85px"
          />
        </Flex.Item>
        <Flex.Item ml={1}>
          <ButtonKeybind
            icon="plus"
            color="transparent"
            content={pendingKeybind?.keybinding || keybind?.keybinding}
            onFinish={(keysDown) => {
              const mods = keysDown.filter((k) => KEY_MODS[k]);
              const keys = keysDown.filter((k) => !KEY_MODS[k]);
              if (keys.length === 0) {
                if (mods.length >= 0) {
                  keys.push(mods.pop());
                } else return;
              }
              setPendingKeybind((pending) => {
                const kb =
                  mods.length > 0 ? `${mods.join('+')}+${keys[0]}` : keys[0];

                if (!pending) {
                  return {
                    ...keybind,
                    keybinding: kb,
                  };
                }

                return {
                  ...pending,
                  keybinding: kb,
                };
              });
            }}
          />
        </Flex.Item>
      </Flex>
      <Flex align="center" mt={1}>
        <Flex.Item grow>
          <Button.Checkbox
            checked={pendingKeybind?.when_xeno ?? keybind?.when_xeno}
            fluid
            onClick={() => {
              setPendingKeybind((pending) => {
                const currentValue =
                  pending?.when_xeno ?? keybind?.when_xeno ?? false;
                if (!pending) {
                  return {
                    ...keybind,
                    when_xeno: !currentValue,
                  };
                }
                return {
                  ...pending,
                  when_xeno: !currentValue,
                };
              });
            }}
          >
            Xenomorphs
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item ml={1} grow>
          <Button.Checkbox
            checked={pendingKeybind?.when_human ?? keybind?.when_human}
            fluid
            onClick={() => {
              setPendingKeybind((pending) => {
                const currentValue =
                  pending?.when_human ?? keybind?.when_human ?? false;
                if (!pending) {
                  return {
                    ...keybind,
                    when_human: !currentValue,
                  };
                }
                return {
                  ...pending,
                  when_human: !currentValue,
                };
              });
            }}
          >
            Humans
          </Button.Checkbox>
        </Flex.Item>
      </Flex>
      {pendingKeybind && (
        <Flex align="center" mt={1}>
          <Flex.Item grow>
            <Button
              fluid
              color="good"
              icon="save"
              disabled={
                !pendingKeybind.keybinding ||
                !pendingKeybind.type ||
                !pendingKeybind.contents ||
                (Array.isArray(pendingKeybind.contents) &&
                  pendingKeybind.contents.length === 0)
              }
              onClick={() => {
                act('set_custom_keybinds', {
                  index: index + 1,
                  keybind: pendingKeybind.keybinding,
                  keybind_type: pendingKeybind.type?.toLowerCase(),
                  contents: pendingKeybind.contents,
                  when_xeno: pendingKeybind.when_xeno ?? false,
                  when_human: pendingKeybind.when_human ?? false,
                });
                setPendingKeybind(undefined);
              }}
            >
              Save Custom Keybind
            </Button>
          </Flex.Item>
          <Flex.Item ml={1}>
            <Button
              color="bad"
              icon="times"
              tooltip="Discard changes"
              onClick={() => setPendingKeybind(undefined)}
            />
          </Flex.Item>
        </Flex>
      )}
      <Divider />
    </Flex.Item>
  );
};

const KeybindsDropdown = (props: {
  readonly selectedTab: string;
  readonly setSelectedTab: (value: React.SetStateAction<string>) => void;
  readonly searchTerm: string;
}) => {
  const { act, data } = useBackend<Data>();
  const { glob_keybinds } = data;
  const { selectedTab, setSelectedTab, searchTerm } = props;

  const dropdownOptions = ['ALL', 'CUSTOM', ...Object.keys(glob_keybinds)];

  return (
    <Dropdown
      width="360px"
      menuWidth="360px"
      selected={selectedTab}
      options={dropdownOptions}
      disabled={!!searchTerm}
      onSelected={(value) => setSelectedTab(value)}
    />
  );
};

export const KeybindElement = (props: { readonly keybind: Keybind }) => {
  const { act, data } = useBackend<Data>();
  const { keybind } = props;
  const { player_keybinds } = data;

  const currentBoundKeys: string[] = [];

  for (const [key, value] of Object.entries(player_keybinds)) {
    for (let i = 0; i < value.length; i++) {
      if (value[i] === keybind.name) {
        currentBoundKeys.push(key);
        break;
      }
    }
  }

  return (
    <Flex id={keybind.name} mt={1}>
      <Flex.Item basis="30%">
        <Box fontSize="115%" color="label" textAlign="center">
          {keybind.full_name}
        </Box>
      </Flex.Item>
      <Flex.Item grow={1}>
        <Flex direction="column">
          {currentBoundKeys.map((val) => (
            <Flex.Item key={val}>
              <ButtonKeybind
                color="transparent"
                content={val}
                onFinish={(keysDown) => {
                  const mods = keysDown.filter((k) => KEY_MODS[k]);
                  const keys = keysDown.filter((k) => !KEY_MODS[k]);
                  if (keys.length === 0) {
                    if (mods.length >= 0) {
                      keys.push(mods.pop());
                    }
                  }
                  act('set_keybind', {
                    keybind_name: keybind.name,
                    old_key: val,
                    key_mods: mods,
                    key: keys.length === 0 ? false : keys[0],
                  });
                }}
              />
            </Flex.Item>
          ))}
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <ButtonKeybind
          icon="plus"
          color="transparent"
          onFinish={(keysDown) => {
            const mods = keysDown.filter((k) => KEY_MODS[k]);
            const keys = keysDown.filter((k) => !KEY_MODS[k]);
            if (keys.length === 0) {
              if (mods.length >= 0) {
                keys.push(mods.pop());
              } else return;
            }
            act('set_keybind', {
              keybind_name: keybind.name,
              key_mods: mods,
              key: keys[0],
            });
          }}
        />
        <Button
          onClick={() =>
            act('clear_keybind', {
              keybinding: keybind.name,
              key: currentBoundKeys,
            })
          }
        >
          Clear
        </Button>
      </Flex.Item>
    </Flex>
  );
};

type KeyBindButtonProps = ButtonProps & {
  readonly onFinish: (keysDown: any) => void;
} & Partial<{
    color: string;
    icon: string;
    tooltip: string;
    tooltipPosition: Placement;
    content: string;
  }>;

export class ButtonKeybind extends Component<KeyBindButtonProps> {
  state: { focused: boolean; keysDown: Record<string, boolean> };
  timer: NodeJS.Timeout;
  constructor(props) {
    super(props);
    this.state = {
      focused: false,
      keysDown: {},
    };
  }

  preventPassthrough(key) {
    key.event.preventDefault();
  }

  doFinish() {
    const { onFinish } = this.props;
    const { keysDown } = this.state;

    const listOfKeys = Object.keys(keysDown).filter(
      (isTrue) => keysDown[isTrue],
    );

    onFinish(listOfKeys);
    (document.activeElement as HTMLElement).blur();
    clearInterval(this.timer);
  }

  handleKeyPress(e) {
    const { keysDown } = this.state;

    e.preventDefault();

    let pressedKey = e.key.toUpperCase();

    this.finishTimerStart(600);

    // Prevents repeating
    if (keysDown[pressedKey] && e.type === 'keydown') {
      return;
    }

    if (KEY_CODE_TO_BYOND[pressedKey]) {
      pressedKey = KEY_CODE_TO_BYOND[pressedKey];
    }

    if (e.keyCode >= 96 && e.keyCode <= 105) {
      pressedKey = 'Numpad' + pressedKey;
    }

    keysDown[pressedKey] = e.type === 'keydown';
    this.setState({
      keysDown: keysDown,
    });
  }

  finishTimerStart(time) {
    clearInterval(this.timer);
    this.timer = setInterval(() => this.doFinish(), time);
  }

  doFocus() {
    this.setState({
      focused: true,
      keysDown: {},
    });
    this.finishTimerStart(2000);
    globalEvents.on('keydown', this.preventPassthrough);
    globalEvents.on('key', this.preventPassthrough);
    globalEvents.on('keyup', this.preventPassthrough);
  }

  doBlur() {
    this.setState({
      focused: false,
      keysDown: {},
    });
    globalEvents.off('keydown', this.preventPassthrough);
    globalEvents.off('key', this.preventPassthrough);
    globalEvents.off('keyup', this.preventPassthrough);
  }

  render() {
    const { focused, keysDown } = this.state;
    const { content, ...rest } = this.props;

    return (
      <Button
        {...rest}
        selected={focused}
        inline
        onClick={(e) => {
          if (focused && Object.keys(keysDown).length) {
            this.doFinish();
            e.preventDefault();
          }
        }}
        onFocus={() => this.doFocus()}
        onBlur={() => this.doBlur()}
        onKeyDown={(e) => this.handleKeyPress(e)}
      >
        {focused
          ? Object.keys(keysDown)
              .filter((isTrue) => keysDown[isTrue])
              .join('+') || content
          : content}
      </Button>
    );
  }
}
