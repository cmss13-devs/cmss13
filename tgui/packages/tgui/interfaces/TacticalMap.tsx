import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Section, Stack, Tabs } from 'tgui/components';
import { ByondUi } from 'tgui/components';
import { Window } from 'tgui/layouts';

interface TacMapProps {
  isXeno: boolean;
  mapRef: string;
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
          color={data.isXeno ? 'purple' : 'blue'}
          selected={false}
          icon={'plus'}
          onClick={() => tryIncrementZ()}
        >
          Move up
        </Tabs.Tab>
        <Tabs.Tab
          key={PAGES.length + 1}
          color={data.isXeno ? 'purple' : 'blue'}
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
    <Window
      width={700}
      height={850}
      theme={data.isXeno ? 'hive_status' : 'crtblue'}
    >
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
                      color={data.isXeno ? 'purple' : 'blue'}
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
        height="100%"
        width="100%"
        params={{
          id: data.mapRef,
          type: 'map',
          'background-color': '#00FF00',
        }}
        className="TacticalMap"
      />
    </Section>
  );
};
