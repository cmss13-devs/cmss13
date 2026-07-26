import type { BooleanLike } from 'common/react';
import { capitalize } from 'common/string';
import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  Input,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';
import { createLogger } from 'tgui/logging';

import { ElectricalPanel } from './common/ElectricalPanel';
import { replaceRegexChars } from './helpers';

type PrintData = {
  name: string;
  index: number;
  can_make: BooleanLike;
  materials: string | Record<string, string>;
  multipliers: Record<string, number> | null;
  has_multipliers: number;
  hidden: BooleanLike;
  recipe_category: string;
};

type Data = {
  queued: { name: string; multiplier: number; index: number }[] | null;
  currently_making: { name: string; multiplier: number } | null;
  materials: Record<string, number>;
  printables: PrintData[];
  electrical: {
    electrified: BooleanLike;
    panel_open: BooleanLike;
    wires: { dec: string; cut: BooleanLike };
    powered: BooleanLike;
  };
  selectable_categories: string[];
  capacity: Record<string, number>;
  queuemax: number;
  theme: string;
};

export const Autolathe = () => {
  const { data } = useBackend<Data>();

  const { queued, theme } = data;

  return (
    <Window width={600} height={600} theme={theme}>
      <Window.Content scrollable>
        <MaterialsData />
        {queued && <QueueList />}
        <PrintablesSection />
      </Window.Content>
    </Window>
  );
};

const MaterialsData = (props) => {
  const { data } = useBackend<Data>();
  const { materials, capacity, currently_making } = data;

  return (
    <Section title="Materials">
      <Flex direction="row" grow>
        {Object.keys(materials).map((category) => (
          <Flex.Item key={category} grow>
            <ProgressBar
              width="99%"
              value={materials[category] / capacity[category]}
            >
              <Box textAlign="center">
                {capitalize(category)}: {materials[category]}/
                {capacity[category]}
              </Box>
            </ProgressBar>
          </Flex.Item>
        ))}
      </Flex>
      {currently_making ? <CurrentlyMaking /> : null}
    </Section>
  );
};

const CurrentlyMaking = (props) => {
  const { data } = useBackend<Data>();
  const { currently_making } = data;

  const MakingName = currently_making
    ? 'Currently making:' +
      capitalize(currently_making.name) +
      (currently_making.multiplier > 1
        ? ' (x' + currently_making.multiplier + ')'
        : '')
    : '';

  return (
    <>
      <Box height="5px" />
      <Button fluid textAlign="center">
        {MakingName}
      </Button>
    </>
  );
};

const QueueList = (props) => {
  const { act, data } = useBackend<Data>();
  const { queued } = data;

  return (
    <Section title="Queue">
      <Flex direction="column">
        {queued?.map((item, index) => (
          <Flex.Item key={index}>
            <Flex direction="row">
              <Flex.Item>
                <Button>
                  {item.index +
                    ': ' +
                    capitalize(item.name) +
                    (item.multiplier > 1 ? ' (x' + item.multiplier + ')' : '')}
                </Button>
                <Box width="5px" />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="xmark"
                  tooltip="Remove"
                  onClick={() =>
                    act('cancel', {
                      index: item.index,
                      name: item.name,
                      multiplier: item.multiplier,
                    })
                  }
                />
              </Flex.Item>
            </Flex>
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

// the below all has to be in one section due to the categories and search params
const PrintablesSection = (props) => {
  const { act, data } = useBackend<Data>();

  const logger = createLogger('autolathe');

  const { materials, printables, selectable_categories } = data;

  const [currentSearch, setSearch] = useState('');

  const categories: string[] = [];
  printables
    .filter((x) => categories.includes(x.recipe_category))
    .map((x) => x.recipe_category);

  const [currentCategory, setCategory] = useState('All');

  const filteredPrintables = printables.filter(
    (val) =>
      (val.recipe_category === currentCategory || currentCategory === 'All') &&
      (!currentSearch ||
        val.name.toLowerCase().match(replaceRegexChars(currentSearch))),
  );

  return (
    <Section fill>
      <Stack vertical fill>
        {selectable_categories.length > 2 && ( // check that it isn't just one category and "all"
          <Stack.Item>
            <Tabs fluid>
              {selectable_categories.map((val) => (
                <Tabs.Tab
                  selected={val === currentCategory}
                  onClick={() => setCategory(val)}
                  key={val}
                >
                  {val}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
        )}
        <Stack.Item>
          <Input
            fluid
            value={currentSearch}
            placeholder="Search for an item"
            onInput={(e, value) => setSearch(value.toLowerCase())}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Flex direction="column">
            {filteredPrintables.map((val, index) => (
              <Flex.Item key={index}>
                <Box>
                  <Flex direction="row">
                    <Flex.Item grow>
                      <Button
                        fluid
                        disabled={!val.can_make}
                        color={val.hidden ? 'red' : null}
                        onClick={() =>
                          act('make', {
                            index: val.index,
                            multiplier: 1,
                          })
                        }
                      >
                        {capitalize(val.name) +
                          ' (' + // sorry for this shitcode, also yes this will break if an autolathe uses more than 2 material types
                          (val.materials[Object.keys(materials)[0]] &&
                          val.materials[Object.keys(materials)[1]]
                            ? val.materials[Object.keys(materials)[0]] +
                              ', ' +
                              val.materials[Object.keys(materials)[1]]
                            : val.materials[Object.keys(materials)[0]]
                              ? val.materials[Object.keys(materials)[0]]
                              : val.materials[Object.keys(materials)[1]]) +
                          ') '}
                      </Button>
                    </Flex.Item>

                    {(val.has_multipliers && (
                      <>
                        <Box width="2.5px" />
                        <Flex.Item>
                          <Flex direction="row">
                            {!!val.multipliers &&
                              Object.keys(val.multipliers).map(
                                (entry, index) => (
                                  <Fragment key={index}>
                                    {index !== 0 ? <Box width="2.5px" /> : null}
                                    <Flex.Item>
                                      <Button
                                        onClick={() =>
                                          act('make', {
                                            index: val.index,
                                            multiplier: entry,
                                          })
                                        }
                                      >
                                        {'x' + entry}
                                      </Button>
                                    </Flex.Item>
                                  </Fragment>
                                ),
                              )}
                          </Flex>
                        </Flex.Item>
                      </>
                    )) ||
                      null}
                  </Flex>
                </Box>
                <Box height="2.5px" />
              </Flex.Item>
            ))}
          </Flex>
          <Box height="10px" />
          <ElectricalPanel />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
