import type { BooleanLike } from 'common/react';
import { capitalizeAll } from 'common/string';
import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  LabeledControls,
  ProgressBar,
  RoundGauge,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';
import { createLogger } from 'tgui/logging';

import { replaceRegexChars } from './helpers';

type PrintData = {
  name: string;
  index: number;
  can_make: BooleanLike;
  sheet_amount: number;
  multipliers: Record<string, number> | null;
  has_multipliers: number;
  hacked: BooleanLike;
  recipe_category: string;
};

type Data = {
  queued: { name: string; multiplier: number; index: number }[] | null;
  currently_making: { name: string; multiplier: number } | null;
  sheet_amount: number;
  printables: PrintData[];
  selectable_categories: string[];
  capacity: number;
  queuemax: number;
  theme: string;
  packer_busy: BooleanLike;
  box_loaded: BooleanLike;
  loaded_box_max_storage: number;
  loaded_box_stored_amount: number;
  loaded_box_load_type: string;
  max_magazine_storage: number;
  number_of_magazines_stored: number;
  ejecting_magazines: BooleanLike;
  max_item_storage: number;
  number_of_items_stored: number;
  ejecting_items: BooleanLike;
};

export const AmmoPacker = () => {
  const { data } = useBackend<Data>();

  const { theme } = data;

  return (
    <Window width={900} height={400} theme={theme}>
      <Window.Content scrollable>
        <Flex flex-direction="row">
          <Flex.Item basis="40%">
            <PackerControl />
            <CurrentlyMaking />
            <QueueList />
          </Flex.Item>
          <Flex.Item>
            <Divider vertical />
          </Flex.Item>
          <Flex.Item basis="60%">
            <MaterialsData />
            <PrintablesSection />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const MaterialsData = (props) => {
  const { data } = useBackend<Data>();
  const { sheet_amount, capacity } = data;

  return (
    <Section title="CARDBOARD SHEETS" width="1-0%">
      <ProgressBar width="100%" value={sheet_amount / capacity}>
        <Box textAlign="center">
          {sheet_amount} / {capacity}
        </Box>
      </ProgressBar>
    </Section>
  );
};

const PackerControl = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    packer_busy,
    box_loaded,
    loaded_box_max_storage,
    loaded_box_stored_amount,
    loaded_box_load_type,
    max_magazine_storage,
    number_of_magazines_stored,
    ejecting_magazines,
    max_item_storage,
    number_of_items_stored,
    ejecting_items,
  } = data;
  const LoadedBoxMax = loaded_box_max_storage ? loaded_box_max_storage : 1;
  const LoadedBoxMaxBad = loaded_box_max_storage
    ? loaded_box_max_storage * 0.33
    : 1;
  return (
    <Section title="MODE: RECYCLING MAGAZINGES">
      <Section
        title="IDLE"
        buttons={
          <>
            <Button icon="play">RUN</Button>
            <Button
              icon="stop"
              onClick={() => act('stop')}
              disabled={!packer_busy}
            >
              STOP
            </Button>
            <Button icon="recycle"> CHANGE MODE</Button>
          </>
        }
      >
        <Flex
          py={3}
          justify="space-evenly"
          align-items="center"
          align-content="center"
          align="center"
        >
          <Flex.Item basis="33%">
            <LabeledControls.Item
              label={
                loaded_box_max_storage
                  ? `CAPACITY: ${loaded_box_max_storage}`
                  : 'CAPACITY: 0'
              }
              nowrap
            >
              <RoundGauge
                value={loaded_box_stored_amount}
                minValue={0}
                maxValue={LoadedBoxMax}
                ranges={{
                  good: [loaded_box_max_storage * 0.66, loaded_box_max_storage],
                  average: [
                    loaded_box_max_storage * 0.33,
                    loaded_box_max_storage * 0.66,
                  ],
                  bad: [0, LoadedBoxMaxBad],
                }}
                format={(x) => `${Math.round(x)} ${loaded_box_load_type}`}
                size={1.75}
                nowrap
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label={box_loaded ? 'LOADED' : 'EMPTY'}
              nowrap
            >
              <Button
                icon="caret-square-up"
                onClick={() => act('eject_box')}
                disabled={!box_loaded || packer_busy}
              >
                EJECT
              </Button>
            </LabeledControls.Item>
          </Flex.Item>
          <Flex.Item order={-1} basis="33%">
            <LabeledControls.Item label="IN STORAGE" nowrap>
              <RoundGauge
                value={number_of_magazines_stored}
                minValue={0}
                maxValue={max_magazine_storage}
                ranges={{
                  good: [max_magazine_storage * 0.66, max_magazine_storage],
                  average: [
                    max_magazine_storage * 0.33,
                    max_magazine_storage * 0.66,
                  ],
                  bad: [0, max_magazine_storage * 0.33],
                }}
                format={(x) => `${Math.round(x)} ` + ' MAGAZINES'}
                size={1.75}
                nowrap
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label={number_of_magazines_stored ? 'LOADED' : 'EMPTY'}
              nowrap
            >
              <Button
                icon="caret-square-up"
                onClick={() => act('eject_magazines')}
                disabled={
                  !number_of_magazines_stored ||
                  (packer_busy && !ejecting_magazines)
                }
                color={ejecting_magazines ? 'orange' : null}
              >
                EJECT
              </Button>
            </LabeledControls.Item>
          </Flex.Item>
          <Flex.Item basis="33%">
            <LabeledControls.Item label="IN STORAGE" nowrap>
              <RoundGauge
                value={number_of_items_stored}
                minValue={0}
                maxValue={max_item_storage}
                ranges={{
                  good: [max_item_storage * 0.66, max_item_storage],
                  average: [max_item_storage * 0.33, max_item_storage * 0.66],
                  bad: [0, max_item_storage * 0.33],
                }}
                format={(x) => `${Math.round(x)} ` + ' ITEMS'}
                size={1.75}
                nowrap
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label={number_of_items_stored ? 'LOADED' : 'EMPTY'}
              nowrap
            >
              <Button
                icon="caret-square-up"
                onClick={() => act('eject_items')}
                disabled={
                  !number_of_items_stored || (packer_busy && !ejecting_items)
                }
                color={ejecting_items ? 'orange' : null}
              >
                EJECT
              </Button>
            </LabeledControls.Item>
          </Flex.Item>
        </Flex>
      </Section>
    </Section>
  );
};

const CurrentlyMaking = (props) => {
  const { data } = useBackend<Data>();
  const { currently_making } = data;

  const MakingName = currently_making
    ? 'PRESSING: ' +
      capitalizeAll(currently_making.name) +
      (currently_making.multiplier > 1
        ? ' (x' + currently_making.multiplier + ')'
        : '')
    : 'PRESSING: ';

  return (
    <Section>
      <Box textAlign="left">{MakingName}</Box>
    </Section>
  );
};

const QueueList = (props) => {
  const { act, data } = useBackend<Data>();
  const { queued } = data;

  return (
    <Section title="QUEUE">
      <Flex direction="column">
        {queued?.map((item, index) => (
          <Flex.Item key={index}>
            <Flex direction="row">
              <Flex.Item>
                <Button>
                  {item.index +
                    ': ' +
                    capitalizeAll(item.name) +
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

  const { printables, selectable_categories } = data;

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
    <Flex direction="column">
      <Flex.Item>
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
                      nowrap
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
                            color={val.hacked ? 'red' : null}
                            onClick={() =>
                              act('make', {
                                index: val.index,
                                multiplier: 1,
                              })
                            }
                          >
                            {capitalizeAll(val.name)}
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
                                        {index !== 0 ? (
                                          <Box width="2.5px" />
                                        ) : null}
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
            </Stack.Item>
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};
