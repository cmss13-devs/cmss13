import { Component } from 'inferno';
import { useBackend } from '../backend';
import { Button, Flex, Section, Box } from '../components';
import { Window } from '../layouts';
import { globalEvents } from '../events.js';

const KEY_MODS = {
  "SHIFT": true,
  "ALT": true,
  "CONTROL": true,
};

export const KeyBinds = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_keybinds } = data;

  return (
    <Window
      width={400}
      height={400}
      resizable
    >
      <Window.Content scrollable>
        <Flex direction="column">
          <Flex.Item>
            <Section title="Settings">
              <Flex direction="column">
                <Flex.Item>
                  <Flex>
                    <Flex.Item grow={1}>
                      <Box color="label">
                        Reset to default:
                      </Box>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        color="red"
                        icon="undo"
                        onClick={() => act("clear_all_keybinds")}
                      />
                    </Flex.Item>
                  </Flex>
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
          {Object.keys(glob_keybinds).map(category => (
            <Flex.Item key={category}>
              <Section title={category}>
                <Flex direction="column">
                  {glob_keybinds[category].map(keybind => (
                    <Flex.Item
                      key={keybind}
                    >
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
          ))}
        </Flex>
      </Window.Content>
    </Window>
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
        <Box
          fontSize="115%"
          color="label"
          textAlign="center"
        >
          {keybind.full_name}
        </Box>
      </Flex.Item>
      <Flex.Item grow={1}>
        <Flex direction="column">
          {currentBoundKeys.map(val => (
            <Flex.Item
              key={val}
            >
              <ButtonKeybind
                color="transparent"
                content={val}
                onFinish={keysDown => {
                  const mods = keysDown.filter(k => KEY_MODS[k]);
                  const keys = keysDown.filter(k => !KEY_MODS[k]);
                  if (keys.length === 0) {
                    if (mods.length >= 0) {
                      keys.push(mods.pop());
                    }
                  }
                  act("set_keybind", {
                    keybind_name: keybind.name,
                    old_key: val,
                    key_mods: mods,
                    key: keys.length === 0? false : keys[0],
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
          onFinish={keysDown => {
            const mods = keysDown.filter(k => KEY_MODS[k]);
            const keys = keysDown.filter(k => !KEY_MODS[k]);
            if (keys.length === 0) {
              if (mods.length >= 0) {
                keys.push(mods.pop());
              } else return;
            }
            act("set_keybind", {
              keybind_name: keybind.name,
              key_mods: mods,
              key: keys[0],
            });
          }}
        />
        <Button
          content="Clear"
          onClick={() => act("clear_keybind", {
            keybinding: keybind.name,
            key: currentBoundKeys,
          })}
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

    const listOfKeys
      = Object.keys(keysDown)
        .filter(isTrue => keysDown[isTrue]);

    onFinish(listOfKeys);
    document.activeElement.blur();
  }

  handleKeyPress(e) {
    const { keysDown } = this.state;

    e.preventDefault();

    if (e.key === "Esc") {
      this.doFinish();
      return;
    }

    let pressedKey = e.key.toUpperCase();
    // Prevents repeating
    if (keysDown[pressedKey] && e.type === "keydown") {
      return;
    }

    if (e.keyCode >= 96 && e.keyCode <= 105) {
      pressedKey = "Numpad" + pressedKey;
    }

    keysDown[pressedKey] = e.type === "keydown";
    this.setState({
      keysDown: keysDown,
    });
  }

  doFocus() {
    this.setState({
      focused: true,
      keysDown: {},
    });
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
    const {
      content,
      ...rest
    } = this.props;

    return (
      <Button
        {...rest}
        content={focused
          ? Object.keys(keysDown)
            .filter(isTrue => keysDown[isTrue])
            .join("+") || content
          : content}
        selected={focused}
        onClick={e => {
          if (focused && Object.keys(keysDown).length) {
            this.doFinish();
            e.preventDefault();
          }
        }}
        onFocus={() => this.doFocus()}
        onBlur={() => this.doBlur()}
        onKeyDown={e => this.handleKeyPress(e)}
        onKeyUp={e => this.handleKeyPress(e)}
      />
    );
  }
}
