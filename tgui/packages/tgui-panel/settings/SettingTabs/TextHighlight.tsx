import { useState } from 'react';
import React from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Divider,
  Flex,
  Input,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui/components';

import { rebuildChat } from '../../chat/actions';
import {
  addHighlightSetting,
  removeHighlightSetting,
  updateHighlightSetting,
} from '../actions';
import {
  selectHighlightKeywords,
  selectHighlightSettingById,
  selectHighlightSettings,
} from '../selectors';

export function TextHighlightSettings(props) {
  const highlightSettings = useSelector(selectHighlightSettings);
  const dispatch = useDispatch();

  return (
    <Section fill scrollable height="250px">
      <Stack vertical>
        <Stack.Item>
          <KeywordMenu />
        </Stack.Item>
        {highlightSettings.map((id, i) => (
          <TextHighlightSetting
            key={i}
            id={id}
            mb={i + 1 === highlightSettings.length ? 0 : '10px'}
          />
        ))}
        <Stack.Item>
          <Box>
            <Button
              color="transparent"
              icon="plus"
              onClick={() => {
                dispatch(addHighlightSetting());
              }}
            >
              Add Highlight Setting
            </Button>
          </Box>
        </Stack.Item>
      </Stack>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          Apply now
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          Can freeze the chat for a while.
        </Box>
      </Box>
    </Section>
  );
}

function TextHighlightSetting(props) {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(selectHighlightSettingById);
  const dispatch = useDispatch();
  const {
    highlightColor,
    highlightText,
    highlightWholeMessage,
    matchWord,
    matchCase,
  } = highlightSettingById[id];

  return (
    <Stack.Item {...rest}>
      <Stack mb={1} color="label" align="baseline">
        <Stack.Item grow>
          <Button
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          >
            Delete
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          >
            Whole Message
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          >
            Exact
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            tooltip="If this option is selected, the highlight will be case-sensitive."
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          >
            Case
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onInput={(e, value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Stack.Item>
      </Stack>
      <TextArea
        height="3em"
        value={highlightText}
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        onChange={(e, value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
    </Stack.Item>
  );
}

const KeywordMenu = (props) => {
  const highlightKeywords = useSelector(selectHighlightKeywords);

  const keywordsExist = highlightKeywords !== null;

  const [tabIndex, setTabIndex] = useState(0);
  // Tab information defined here.
  // [name, color, contents]
  const tabs: Array<[string, string, Array<string>]> = [
    ['Global', 'white', ['fullName', 'fullJob']],
    ['Human', 'good', ['firstName', 'lastName', 'middleName', 'jobCommTitle']],
    ['Xenomorph', 'xeno', ['xenoPrefix', 'xenoNumber', 'xenoPostfix']],
  ];
  const [_tabTitle, tabColor, selectedTabEntries] = tabs[tabIndex];

  return (
    <>
      <Flex direction="horizontal">
        <Flex.Item grow>
          <Collapsible title="Keywords">
            {keywordsExist ? (
              <>
                <Box color="label">
                  Instances of the following triggers (e.g. $fullName$) in
                  highlight strings will be replaced with the coresponding
                  value, if available.
                </Box>
                {/* Tab selection. */}
                <Tabs px="0.75rem" mb="0">
                  {tabs.map(([title, _tabEntries], i) => (
                    <Tabs.Tab
                      key={i}
                      selected={i === tabIndex}
                      color={tabColor}
                      onClick={() => setTabIndex(i)}
                    >
                      {title}
                    </Tabs.Tab>
                  ))}
                </Tabs>
                {/* Tab contents. */}
                <Flex wrap backgroundColor="hsl(0, 0%, 11%)" p="0.75rem" pb="0">
                  {selectedTabEntries.map((keywordName, index) => {
                    const [trigger, replacement] = [
                      '$' + keywordName + '$',
                      // Em-dash if value is null/empty.
                      highlightKeywords[keywordName] || '-',
                    ];

                    return (
                      <Flex.Item width="33%" mb="0.75rem" key="index">
                        <Box>{trigger}</Box>
                        <Box color="label" style={{ userSelect: 'none' }}>
                          {replacement}
                        </Box>
                      </Flex.Item>
                    );
                  })}
                </Flex>
              </>
            ) : (
              <Box color="label">
                Keywords unavailable. Occupy a character to generate highlight
                keywords.
              </Box>
            )}
          </Collapsible>
        </Flex.Item>
        {/* Refresh button. */}
        <Flex.Item ml="0.5rem">
          <Button
            color="transparent"
            tooltip="Refresh keywords"
            tooltipPosition="left"
            icon="refresh"
            onClick={() => Byond.sendMessage('refresh_keywords')}
          />
        </Flex.Item>
      </Flex>
      <Divider />
    </>
  );
};
