import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

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
];

type Data = {
  uscm_map: string | null;
  uscm_svg: string | null;
  xeno_map: string | null;
  xeno_svg: string | null;
  map_fallback: string;
  factions: string[];
};

export const TacmapViewer = (props) => {
  const { data } = useBackend<Data>();
  const { uscm_map, xeno_map, uscm_svg, xeno_svg, map_fallback } = data;

  const initialIndex =
    data.factions && data.factions.length
      ? Math.max(
          0,
          PAGES.findIndex((p) => p.title === data.factions[0]),
        )
      : 0;

  const [pageIndex, setPageIndex] = useState(initialIndex);

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
                key={pageIndex}
                flatImage={(pageIndex === 0 ? uscm_map : xeno_map) || ''}
                backupImage={map_fallback}
              />
              <DrawnMap
                key={pageIndex + 2} // +2 because the other page is +1
                flatImage={(pageIndex === 0 ? uscm_svg : xeno_svg) || ''}
                backupImage={map_fallback}
                showLoading={false}
              />
            </div>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
