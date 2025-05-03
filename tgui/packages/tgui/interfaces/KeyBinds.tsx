import type { Placement } from '@popperjs/core';
import { Component, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Flex, Input, Section } from 'tgui/components';
import { globalEvents } from 'tgui/events';
import { Window } from 'tgui/layouts';

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
  glob_keybinds: Record<string, Keybind[]>;
  byond_keymap: Record<string, string>;
};

export const KeyBinds = (props) => {
  const { act, data } = useBackend<Data>();
  const { player_keybinds, glob_keybinds, byond_keymap } = data;

  const [selectedTab, setSelectedTab] = useState('ALL');
  const [searchTerm, setSearchTerm] = useState('');

  const keybinds_to_use =
    searchTerm.length || selectedTab === 'ALL'
      ? getAllKeybinds(glob_keybinds)
      : glob_keybinds[selectedTab];

  const filteredKeybinds = keybinds_to_use.filter((val) =>
    val.full_name.toLowerCase().match(searchTerm),
  );

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
                        onInput={(_, value) => setSearchTerm(value)}
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
                          if (!targetEntry) {
                            return;
                          }
                          // If a keybind was found, scroll to the first match currently rendered.
                          for (let i = 0; i < targetEntry.length; i++) {
                            const element = document.getElementById(
                              targetEntry[i],
                            );
                            if (element) {
                              element.scrollIntoView();
                              break;
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
            {selectedTab === 'ALL' && !searchTerm.length
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
              : filteredKeybinds.map((keybind) => (
                  <Flex.Item key={keybind.full_name}>
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
        </Flex>
      </Window.Content>
    </Window>
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

  const dropdownOptions = ['ALL', ...Object.keys(glob_keybinds)];

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
