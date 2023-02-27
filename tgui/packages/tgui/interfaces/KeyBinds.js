import { Component } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, Flex, Section, Box, Input, Dropdown } from '../components';
import { Window } from '../layouts';
import { globalEvents } from '../events.js';
import { createLogger } from '../logging';

const KEY_MODS = {
  'SHIFT': true,
  'ALT': true,
  'CONTROL': true,
};

const getAllKeybinds = (glob_keybinds) => {
  const all_keybinds = new Array();
  Object.keys(glob_keybinds).map((x) => all_keybinds.push(...glob_keybinds[x]));
  return all_keybinds;
};

export const KeyBinds = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_keybinds } = data;

  const [selectedTab, setSelectedTab] = useLocalState(
    context,
    'progress',
    'ALL'
  );

  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', '');

  const keybinds_to_use =
    searchTerm.length || selectedTab === 'ALL'
      ? getAllKeybinds(glob_keybinds)
      : glob_keybinds[selectedTab];

  const logger = createLogger('waa');

  logger.warn(keybinds_to_use);

  const filteredKeybinds = keybinds_to_use.filter((val) =>
    val.full_name.toLowerCase().match(searchTerm)
  );

  return (
    <Window width={400} height={500} resizable>
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
                    onClick={() => act('clear_all_keybinds')}>
                    Reset to Default
                  </Button>
                </Flex.Item>
              }>
              <Flex direction="column">
                <Flex.Item>
                  <Box height="5px" />
                  <Input
                    value={searchTerm}
                    onInput={(_, value) => setSearchTerm(value)}
                    placeholder="Search..."
                    fluid
                  />
                </Flex.Item>
                <Flex.Item>
                  <Box height="5px" />
                  <KeybindsDropdown />
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

const KeybindsDropdown = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_keybinds } = data;
  const [selectedTab, setSelectedTab] = useLocalState(
    context,
    'progress',
    'ALL'
  );

  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', '');

  const dropdownOptions = ['ALL', ...Object.keys(glob_keybinds)];

  return (
    <Dropdown
      width="360px"
      selected={selectedTab}
      options={dropdownOptions}
      disabled={searchTerm.length}
      onSelected={(value) => setSelectedTab(value)}
    />
  );
};

export const KeybindElement = (props, context) => {
  const { act, data } = useBackend(context);
  const { keybind } = props;
  const { keybinds } = data;

  const currentBoundKeys = [];

  for (const [key, value] of Object.entries(keybinds)) {
    for (let i = 0; i < value.length; i++) {
      if (value[i] === keybind.name) {
        currentBoundKeys.push(key);
        break;
      }
    }
  }

  return (
    <Flex mt={1}>
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
          content="Clear"
          onClick={() =>
            act('clear_keybind', {
              keybinding: keybind.name,
              key: currentBoundKeys,
            })
          }
        />
      </Flex.Item>
    </Flex>
  );
};

export class ButtonKeybind extends Component {
  constructor() {
    super();
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
      (isTrue) => keysDown[isTrue]
    );

    onFinish(listOfKeys);
    document.activeElement.blur();
    clearInterval(this.timer);
  }

  handleKeyPress(e) {
    const { keysDown } = this.state;

    e.preventDefault();

    let pressedKey = e.key.toUpperCase();

    this.finishTimerStart(200);

    // Prevents repeating
    if (keysDown[pressedKey] && e.type === 'keydown') {
      return;
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
  }

  doBlur() {
    this.setState({
      focused: false,
      keysDown: {},
    });
    globalEvents.off('keydown', this.preventPassthrough);
  }

  render() {
    const { focused, keysDown } = this.state;
    const { content, ...rest } = this.props;

    return (
      <Button
        {...rest}
        content={
          focused
            ? Object.keys(keysDown)
              .filter((isTrue) => keysDown[isTrue])
              .join('+') || content
            : content
        }
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
      />
    );
  }
}
