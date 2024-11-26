import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Flex, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { DrawnMap } from './DrawnMap';

const PAGES = [
  {
    title: 'USCM',
    color: 'blue',
    icon: 'medal',
  },
  {
    title: 'Hive',
    color: 'purple',
    icon: 'star',
  },
  {
    title: 'UPP',
    color: 'darkgreen',
    icon: 'medal',
  },
];

export const TacmapAdminPanel = (props) => {
  const { data } = useBackend();
  const {
    uscm_map,
    xeno_map,
    upp_map,
    uscm_svg,
    xeno_svg,
    upp_svg,
    uscm_ckeys,
    xeno_ckeys,
    upp_ckeys,
    uscm_names,
    xeno_names,
    upp_names,
    uscm_times,
    xeno_times,
    upp_times,
    uscm_selection,
    xeno_selection,
    upp_selection,
    map_fallback,
    last_update_time,
  } = data;

  const [pageIndex, setPageIndex] = useState(0);

  const maps = [uscm_map, xeno_map, upp_map];
  const svgs = [uscm_svg, xeno_svg, upp_svg];
  const ckeys = [uscm_ckeys, xeno_ckeys, upp_ckeys];
  const names = [uscm_names, xeno_names, upp_names];
  const times = [uscm_times, xeno_times, upp_times];
  const selections = [uscm_selection, xeno_selection, upp_selection];

  return (
    <Window
      width={600}
      height={800}
      theme={pageIndex === 0 ? 'ntos' : 'hive_status'}
      resizable
    >
      <Window.Content scrollable>
        <Stack direction="column" fill>
          <Stack.Item basis="content" grow={0} pb={1}>
            <Tabs>
              {PAGES.map((page, i) => (
                <Tabs.Tab
                  key={i}
                  color={page.color}
                  selected={i === pageIndex}
                  icon={page.icon}
                  onClick={() => setPageIndex(i)}
                >
                  {page.title}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item mx={0} basis="content">
            <FactionPage
              pageIndex={pageIndex}
              svg={svgs[pageIndex]}
              ckeys={ckeys[pageIndex]}
              names={names[pageIndex]}
              times={times[pageIndex]}
              selected_map={selections[pageIndex]}
            />
          </Stack.Item>
          <Stack.Item mx={0} grow={0}>
            <div justify="center" align="center" fontSize="30px">
              <DrawnMap
                key={last_update_time + pageIndex}
                svgData={svgs[pageIndex]}
                flatImage={maps[pageIndex]}
                backupImage={map_fallback}
              />
            </div>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const FactionPage = (props) => {
  const { act } = useBackend();
  const { svg, ckeys, names, times, selected_map, pageIndex } = props;

  return (
    <Section
      title={`${PAGES[pageIndex].title} Maps`}
      buttons={
        <Button
          icon="fa-solid fa-download"
          tooltip="Attempt to send flat tacmap data for the current selection. Use this if the map is incorrectly a wiki map."
          tooltipPosition="bottom"
          ml={0.5}
          onClick={() =>
            act('recache', {
              page: pageIndex,
            })
          }
        >
          Fix Cache
        </Button>
      }
    >
      {Object(ckeys).map((ckey, ckey_index) => (
        <Flex
          direction="row"
          key={ckey_index}
          backgroundColor={ckey_index % 2 === 1 ? 'rgba(255,255,255,0.1)' : ''}
        >
          <Flex.Item grow={0} basis="content" mx={0.5} mt={0.8}>
            <Button.Checkbox
              textAlign="center"
              verticalAlignContent="bottom"
              checked={selected_map === ckey_index}
              disabled={selected_map === ckey_index}
              onClick={() =>
                act('change_selection', {
                  page: pageIndex,
                  index: ckey_index,
                })
              }
            >
              View
            </Button.Checkbox>
          </Flex.Item>
          <Flex.Item grow={1} align="center" m={1} p={0.2}>
            {names[ckey_index]} ({ckey}) - {times[ckey_index]}
          </Flex.Item>
          <Flex.Item grow={0} basis="content" mr={0.5} mt={0.8}>
            <Button.Confirm
              icon="trash"
              color="white"
              confirmColor="bad"
              textAlign="center"
              verticalAlignContent="bottom"
              width={6.5}
              disabled={selected_map !== ckey_index || svg === null}
              onClick={() =>
                act('delete', {
                  page: pageIndex,
                  index: ckey_index,
                })
              }
            >
              Delete
            </Button.Confirm>
          </Flex.Item>
        </Flex>
      ))}
    </Section>
  );
};
