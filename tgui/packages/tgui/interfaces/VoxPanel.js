import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, Flex, Section, Tabs, Box, Input, Slider } from '../components';
import { KEY_CTRL, KEY_SHIFT } from 'common/keycodes';
import { Window } from '../layouts';

const PAGES = [
  {
    title: 'Send VOX',
    component: () => SendVOX,
    color: "white",
    icon: "share",
  },
  {
    title: 'Sound List',
    component: () => SoundList,
    color: "red",
    icon: "table",
  },
];

export const VoxPanel = (props, context) => {
  const { data } = useBackend(context);

  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 0);

  const PageComponent = PAGES[pageIndex].component();

  return (
    <Window
      width={500}
      height={460}
    >
      <Window.Content scrollable>
        <Tabs>
          {PAGES.map((page, i) => {
            if (page.canAccess && !page.canAccess(data)) {
              return;
            }

            return (
              <Tabs.Tab
                key={i}
                color={page.color}
                selected={i === pageIndex}
                icon={page.icon}
                onClick={() => setPageIndex(i)}>
                {page.title}
              </Tabs.Tab>
            );
          })}
        </Tabs>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const SendVOX = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_vox_types, factions } = data;

  const voxRegexes = {};
  const vox_keys = Object.keys(glob_vox_types);
  for (let i = 0; i < vox_keys.length; i++) {
    const key = vox_keys[i];
    let regexString = "\\b"+Object.keys(glob_vox_types[key]).join("\\b|\\b")+"\\b";
    regexString = regexString.replace(/!/g, "");
    regexString = regexString.replace(/\./g, "\\.");
    voxRegexes[key] = new RegExp(regexString, "g");
  }

  const [voxRegex, setVoxRegex]
    = useLocalState(context, "voxRegex", null);

  const [voxType, setVoxType]
    = useLocalState(context, "voxType", null);

  const [message, setMessage]
    = useLocalState(context, "message", "");

  const [volume, setVolume]
    = useLocalState(context, "volume", 100);

  const [currentFaction, setCurrentFaction]
    = useLocalState(context, "currentFaction", { [factions[0]]: true });

  const handleFactionSet = (val, keysDown) => {
    if (keysDown[KEY_CTRL]) {
      currentFaction[val] = true;
      setCurrentFaction(currentFaction);
    } else if (keysDown[KEY_SHIFT]) {
      let [
        startSelecting,
        foundClickedValue,
        finishedSelecting,
      ] = (false, false, false);
      const toSelect = factions.filter(value => {
        if (finishedSelecting) return false;

        if (val === value) {
          foundClickedValue = true;
          if (startSelecting) {
            startSelecting = false;
            finishedSelecting = true;
            return true;
          } else {
            startSelecting = true;
            return true;
          }
        }

        if (currentFaction[value]) {
          if (foundClickedValue) {
            startSelecting = false;
            finishedSelecting = true;
            return true;
          } else {
            startSelecting = true;
            return true;
          }
        }

        if (startSelecting) {
          return true;
        }
      });
      for (let i = 0; i < toSelect.length; i++) {
        currentFaction[toSelect[i]] = true;
      }
      setCurrentFaction(currentFaction);
    } else {
      setCurrentFaction({ [val]: true });
    }
  };

  const [validWords, setValidWords]
    = useLocalState(context, "valid_words", []);

  const handleSetMessage = msg => {
    setMessage(msg);

    if (!voxRegex) return;

    // matchAll not available on ie :clap:
    const foundWords = msg.match(voxRegex);
    setValidWords(foundWords || []);
  };

  return (
    <Fragment>
      <Flex direction="row">
        <Flex.Item grow={1}>
          <Section
            title="Faction Select"
            fill
            buttons={(
              <Button
                content="Select All"
                color="transparent"
                onClick={() => {
                  for (let i = 0; i < factions.length; i++) {
                    currentFaction[factions[i]] = true;
                  }
                  setCurrentFaction(currentFaction);
                }}
              />
            )}
          >
            <ComboBox
              buttons={factions}
              selected={currentFaction}
              onSelected={(val, keysDown) => handleFactionSet(val, keysDown)}
              height={15}
            />
          </Section>
        </Flex.Item>
        <Flex.Item grow={1} ml={1}>
          <Section title="VOX Type Select" fill>
            <ComboBox
              buttons={Object.keys(glob_vox_types)}
              selected={voxType}
              onSelected={(val, keysDown) => {
                setVoxRegex(voxRegexes[val]);
                setVoxType(val);
              }}
              height={15}
            />
          </Section>
        </Flex.Item>
      </Flex>
      <Flex mt={1} direction="column">
        <Section title="Sentence">
          <Flex.Item grow={1}>
            <Input
              fluid
              value={message}
              onInput={(e, val) => handleSetMessage(val)}
            />
          </Flex.Item>
          <Flex.Item mt={1}>
            <Slider
              value={volume}
              onChange={(e, value) => setVolume(value)}
              step={5}
              stepPixelSize={20}
              minValue={0}
              maxValue={100}
              fluid
            >
              Volume: {volume}
            </Slider>
          </Flex.Item>
          <Flex.Item mt={1}>
            <Flex>
              <Flex.Item grow={1}>
                <Button
                  content="Send to Self"
                  fluid
                  onClick={() => act("play_to_self", {
                    vox_type: voxType,
                    message: message,
                    volume: volume,
                  })}
                />
              </Flex.Item>
              <Flex.Item ml={1} grow={1}>
                <Button
                  content="Send to Factions"
                  fluid
                  onClick={() => act("play_to_players", {
                    vox_type: voxType,
                    message: message,
                    factions: Object.keys(currentFaction),
                    volume: volume,
                  })}
                />
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item mt={1}>
            <Box inline backgroundColor="blue" pl={1} pr={1}>
              Valid Words:
            </Box>
            <Box ml={1} color="white" fontSize="14px" inline>
              {validWords.join(" ")}
            </Box>
          </Flex.Item>
        </Section>
      </Flex>
    </Fragment>
  );
};

const SoundList = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_vox_types } = data;

  const [voxType, setVoxType]
    = useLocalState(context, "voxFilesType", null);

  const [currentSearch, setCurrentSearch]
    = useLocalState(context, "current_search", "");

  return (
    <Flex direction="column">
      <Flex.Item grow={1}>
        <Section title="VOX Type Select" fill>
          <ComboBox
            buttons={Object.keys(glob_vox_types)}
            selected={voxType}
            onSelected={(val, keysDown) => setVoxType(val)}
            height={6}
          />
        </Section>
      </Flex.Item>
      {!!voxType && (
        <Flex.Item mt={1}>
          <Section title="Sound Files">
            <Input
              fluid
              value={currentSearch}
              onInput={(e, val) => setCurrentSearch(val)}
            />
            <Flex
              wrap="wrap"
              justify="space-evenly"
            >
              {Object.keys(glob_vox_types[voxType])
                .filter(val => val.match(currentSearch))
                .map(val => (
                  <Flex.Item key={val} ml={1} mt={1}>
                    <Button
                      content={val}
                      onClick={() => act("play_to_self", {
                        vox_type: voxType,
                        message: val,
                      })}
                    />
                  </Flex.Item>
                ))}
            </Flex>
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};

export const ComboBox = (props, context) => {
  const {
    onSelected,
    selected,
    buttons,
    width,
    height = 10,
    grow,
    ...rest
  } = props;

  const keysDown = {};
  const handleCombos = e => {
    e.preventDefault();
    keysDown[e.keyCode] = e.type === "keydown";
  };

  const handleOnClick = (e, val) => {
    // Thanks to shift + click selecting everything,
    // this needs to be placed down.
    if (document.selection && document.selection.empty) {
      document.selection.empty();
    } else if (window.getSelection) {
      const sel = window.getSelection();
      sel.removeAllRanges();
    }
    onSelected(val, keysDown);
  };

  return (
    <Box props={rest}>
      <Flex width={width} height={height}>
        <Flex.Item grow={1}>
          <Section
            scrollable
            fill
            level={2}
            tabIndex={0}
            onKeyDown={handleCombos}
            onKeyUp={handleCombos}
            onSelectStart={() => false}
          >
            <Flex direction="column">
              {buttons.map(val => (
                <Flex.Item key={val}>
                  <Button
                    color="transparent"
                    fluid
                    content={val}
                    selected={typeof selected === "object" && selected
                      ? selected[val]
                      : selected === val}
                    onClick={e => handleOnClick(e, val)}
                  />
                </Flex.Item>
              ))}
            </Flex>
          </Section>
        </Flex.Item>
      </Flex>
    </Box>
  );
};
