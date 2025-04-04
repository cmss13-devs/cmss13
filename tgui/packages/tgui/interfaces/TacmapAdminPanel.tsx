import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { DrawnMap } from './DrawnMap';

const PAGES = [
  {
    title: 'USCM',
    component: () => FactionPage,
    color: 'blue',
    icon: 'medal',
  },
  {
    title: 'Hive',
    component: () => FactionPage,
    color: 'purple',
    icon: 'star',
  },
];

type Data = {
  uscm_ckeys: string[];
  uscm_names: string[];
  uscm_times: string[];
  xeno_ckeys: string[];
  xeno_names: string[];
  xeno_times: string[];
  uscm_map: string | null;
  uscm_svg: (string | number | CanvasGradient | CanvasPattern)[];
  xeno_map: string | null;
  xeno_svg: (string | number | CanvasGradient | CanvasPattern)[];
  uscm_selection: number;
  xeno_selection: number;
  map_fallback: string;
  last_update_time: number;
};

export const TacmapAdminPanel = (props) => {
  const { data } = useBackend<Data>();
  const {
    uscm_map,
    xeno_map,
    uscm_svg,
    xeno_svg,
    uscm_ckeys,
    xeno_ckeys,
    uscm_names,
    xeno_names,
    uscm_times,
    xeno_times,
    uscm_selection,
    xeno_selection,
    map_fallback,
    last_update_time,
  } = data;

  const [pageIndex, setPageIndex] = useState(0);

  const PageComponent = PAGES[pageIndex].component();

  return (
    <Window
      width={600}
      height={800}
      theme={pageIndex === 0 ? 'ntos' : 'hive_status'}
    >
      <Window.Content scrollable>
        <Stack direction="column" fill>
          <Stack.Item basis="content" grow={0} pb={1}>
            <Tabs>
              {PAGES.map((page, i) => {
                return (
                  <Tabs.Tab
                    key={i}
                    color={page.color}
                    selected={i === pageIndex}
                    icon={page.icon}
                    onClick={() => setPageIndex(i)}
                  >
                    {page.title}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
          <Stack.Item mx={0} basis="content">
            <PageComponent
              svg={pageIndex === 0 ? uscm_svg : xeno_svg}
              ckeys={pageIndex === 0 ? uscm_ckeys : xeno_ckeys}
              names={pageIndex === 0 ? uscm_names : xeno_names}
              times={pageIndex === 0 ? uscm_times : xeno_times}
              selected_map={pageIndex === 0 ? uscm_selection : xeno_selection}
              is_uscm={pageIndex === 0}
            />
          </Stack.Item>
          <Stack.Item mx={0} grow={0}>
            <div
              style={{
                justifyContent: 'center',
                textAlign: 'center',
                fontSize: '30px',
              }}
            >
              <DrawnMap
                key={last_update_time + pageIndex}
                svgData={pageIndex === 0 ? uscm_svg : xeno_svg}
                flatImage={(pageIndex === 0 ? uscm_map : xeno_map) || ''}
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
  const { svg, ckeys, names, times, selected_map, is_uscm } = props;

  return (
    <Section
      title={is_uscm ? 'USCM Maps' : 'Xenomorph Maps'}
      buttons={
        <Button
          icon="fa-solid fa-download"
          tooltip="Attempt to send flat tacmap data for the current selection. Use this if the map is incorrectly a wiki map."
          tooltipPosition="bottom"
          ml={0.5}
          onClick={() =>
            act('recache', {
              uscm: is_uscm,
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
                  uscm: is_uscm,
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
                  uscm: is_uscm,
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
