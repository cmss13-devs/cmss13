import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Section, Stack, Tabs } from 'tgui/components';
import { ByondUi } from 'tgui/components';
import { Window } from 'tgui/layouts';

interface TacMapProps {
  mapRef: string;
  mapPixelSizeX: number;
  mapPixelSizeY: number;
  isXeno: boolean;
  canChangeZ: boolean;
}

const PAGES = [
  {
    title: 'Live Tacmap',
    canOpen: () => {
      return true;
    },
    component: () => ViewMapPanel,
    icon: 'map',
  },
];

export const TacticalMap = (props) => {
  const { data, act } = useBackend<TacMapProps>();
  const [pageIndex, setPageIndex] = useState(0);
  const PageComponent = PAGES[pageIndex].component();

  const handleTacmapOnClick = (i: number, pageTitle: string) => {
    setPageIndex(i);
    act('menuSelect', {
      selection: pageTitle,
    });
  };

  const getTheme = (props: TacMapProps): string => {
    if (props.isXeno) {
      return 'hive_status';
    } else {
      return 'crtblue';
    }
  };

  const getThemeColor = (props: TacMapProps): string => {
    if (props.isXeno) {
      return 'purple';
    } else {
      return 'blue';
    }
  };

  const tryIncrementZ = () => {
    act('changeZ', {
      amount: 1,
    });
  };

  const tryDecrementZ = () => {
    act('changeZ', {
      amount: -1,
    });
  };

  const getZTabs = () => {
    if (!data.canChangeZ) return;

    return (
      <>
        <Tabs.Tab
          key={PAGES.length}
          color={getThemeColor(data)}
          selected={false}
          icon={'plus'}
          onClick={() => tryIncrementZ()}
        >
          Move up
        </Tabs.Tab>
        <Tabs.Tab
          key={PAGES.length + 1}
          color={getThemeColor(data)}
          selected={false}
          icon={'minus'}
          onClick={() => tryDecrementZ()}
        >
          Move down
        </Tabs.Tab>
      </>
    );
  };

  return (
    <Window width={700} height={850} theme={getTheme(data)}>
      <Window.Content>
        <Section
          fitted
          width="688px"
          fontSize="20px"
          textAlign="center"
          title="Tactical Map Options"
        >
          <Stack justify="center" align="center" fontSize="15px">
            <Stack.Item>
              <Tabs height="37.5px">
                {PAGES.map((page, i) => {
                  return (
                    <Tabs.Tab
                      key={i}
                      color={getThemeColor(data)}
                      selected={i === pageIndex}
                      icon={page.icon}
                      onClick={() => handleTacmapOnClick(i, page.title)}
                    >
                      {page.title}
                    </Tabs.Tab>
                  );
                })}
                {getZTabs()}
              </Tabs>
            </Stack.Item>
          </Stack>
        </Section>
        <PageComponent fitted />
      </Window.Content>
    </Window>
  );
};

const ViewMapPanel = (props) => {
  const { data } = useBackend<TacMapProps>();

  return (
    <Section fill fitted height="86%">
      <ByondUi
        winsetParams={{
          id: data.mapRef,
          type: 'map',
          'background-color': '#00FF00',
        }}
        boxProps={{
          height: '100%',
          width: '100%',
          className: 'TacticalMap',
        }}
        zoomDrawingMode={{
          type: 'ManuallyCalculate',
          nativeSize: [data.mapPixelSizeX, data.mapPixelSizeY],
        }}
      />
    </Section>
  );
};
