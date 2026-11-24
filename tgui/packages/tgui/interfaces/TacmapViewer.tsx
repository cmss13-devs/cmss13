import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { DrawnMap } from './DrawnMap';
import { clamp } from 'common/math';

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
];

type Data = {
  uscm_maps: string[] | null;
  uscm_drawings: string[] | null;
  xeno_maps: string[] | null;
  xeno_drawings: string[] | null;
  map_fallback: string;
  factions: string[];
  ground_zs: number[];
};

export const TacmapViewer = (props) => {
  const { data } = useBackend<Data>();
  const {
    uscm_maps,
    xeno_maps,
    uscm_drawings,
    xeno_drawings,
    map_fallback,
    ground_zs,
  } = data;

  const initialIndex =
    data.factions && data.factions.length
      ? Math.max(
          0,
          PAGES.findIndex((p) => p.title === data.factions[0]),
        )
      : 0;

  const [pageIndex, setPageIndex] = useState(initialIndex);
  const [currentZ, setCurrentZ] = useState(0);

  function handleAdjustment(adjustment: number) {
    setCurrentZ((prev) => clamp(prev + adjustment, 0, ground_zs.length - 1));
  }

  const uscm_map = uscm_maps?.[currentZ] ?? '';
  const uscm_drawing = uscm_drawings?.[currentZ] ?? '';
  const xeno_map = xeno_maps?.[currentZ] ?? '';
  const xeno_drawing = xeno_drawings?.[currentZ] ?? '';
  const current_map = pageIndex === 0 ? uscm_map : xeno_map;
  const current_drawing = pageIndex === 0 ? uscm_drawing : xeno_drawing;

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
                if (
                  data.factions &&
                  !data.factions.includes(page.title) &&
                  data.factions.length > 0
                ) {
                  return null;
                }
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
          <Stack.Item mx={0} grow={0}>
            <div
              style={{
                justifyContent: 'center',
                textAlign: 'center',
                fontSize: '30px',
              }}
            >
              <DrawnMap
                key={current_map + pageIndex}
                flatImage={current_map}
                backupImage={map_fallback}
              />
              <DrawnMap
                key={current_drawing + pageIndex + 2} // +2 because the other page is +1
                flatImage={current_drawing}
                backupImage={map_fallback}
                showLoading={false}
              />
            </div>
          </Stack.Item>
          <Stack.Item>
            <Flex direction="row" justify="space-between">
              <Flex.Item>
                <Button
                  icon="chevron-left"
                  width={3}
                  onClick={() => handleAdjustment(-1)}
                  disabled={currentZ == 0}
                  textAlign="left"
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="chevron-right"
                  width={3}
                  onClick={() => handleAdjustment(1)}
                  disabled={currentZ == ground_zs.length - 1}
                  textAlign="right"
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
