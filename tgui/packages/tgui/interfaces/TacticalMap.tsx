import { useBackend, useLocalState } from '../backend';
import { Button, Dropdown, Section, Stack, ProgressBar, Box, Tabs } from '../components';
import { Window } from '../layouts';
import { CanvasLayer } from './CanvasLayer';
import { DrawnMap } from './DrawnMap';
import { ByondUi } from '../components';

interface TacMapProps {
  toolbarColorSelection: string;
  toolbarUpdatedSelection: string;
  updatedCanvas: boolean;
  themeId: number;
  svgData: any;
  canViewHome: number;
  canDraw: number;
  isXeno: boolean;
  flatImage: string;
  mapRef: any;
  currentMenu: string;
  worldtime: any;
  nextCanvasTime: any;
  canvasCooldown: any;
  exportedTacMapImage: any;
}

const PAGES = [
  {
    title: 'tacmap',
    component: () => ViewMapPanel,
    icon: 'map',
    canAccess: (data) => {
      return data.canViewHome;
    },
  },
  {
    title: 'old canvas',
    component: () => OldMapPanel,
    icon: 'eye',
    canAccess: () => {
      return 1;
    },
  },
  {
    title: 'new canvas',
    component: () => DrawMapPanel,
    icon: 'paintbrush',
    canAccess: (data) => {
      return data.canDraw;
    },
  },
];

const themes = [
  {
    'theme': 'default',
    'button-color': 'black',
  },
  {
    'theme': 'crtblue',
    'button-color': 'blue',
  },
  {
    'theme': 'xeno',
    'button-color': 'purple',
  },
];

const colorOptions = [
  'black',
  'red',
  'orange',
  'blue',
  'purple',
  'green',
  'brown',
];

const colors: Record<string, string> = {
  'black': '#000000',
  'red': '#FC0000',
  'orange': '#F59A07',
  'blue': '#0561F5',
  'purple': '#C002FA',
  'green': '#02c245',
  'brown': '#5C351E',
};

export const TacticalMap = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 0);
  const PageComponent = PAGES[pageIndex].component();

  const handleTacmapOnClick = (i, pageTitle) => {
    setPageIndex(i);
    act('menuSelect', {
      selection: pageTitle,
    });
  };

  return (
    <Window width={650} height={850} theme={data.isXeno ? 'xeno' : 'crtblue'}>
      <Window.Content>
        <Section
          fontSize="20px"
          textAlign="center"
          title="Tactical Map Options"
          justify="space-evenly">
          <Stack justify="center" align="center" fontSize="15px">
            <Stack.Item>
              <Tabs>
                {PAGES.map((page, i) => {
                  if (page.canAccess(data) === 0) {
                    return;
                  }
                  return (
                    <Tabs.Tab
                      key={i}
                      color={data.isXeno ? 'purple' : 'blue'}
                      selected={i === pageIndex}
                      icon={page.icon}
                      onClick={() => handleTacmapOnClick(i, page.title)}>
                      {page.title}
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            </Stack.Item>
          </Stack>
        </Section>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const ViewMapPanel = (props, context) => {
  const { data } = useBackend<TacMapProps>(context);
  return (
    <Section fill>
      {data.canViewHome === 1 && (
        <ByondUi
          params={{
            id: data.mapRef,
            type: 'map',
          }}
          class="TacticalMap"
        />
      )}
    </Section>
  );
};

const OldMapPanel = (props, context) => {
  const { data } = useBackend<TacMapProps>(context);
  return (
    <Section fill justify="center" align="center" fontSize="30px">
      {data.flatImage ? (
        <DrawnMap svgData={data.svgData} flatImage={data.flatImage} />
      ) : (
        'Please wait for a new tacmap announcement'
      )}
    </Section>
  );
};

const DrawMapPanel = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);

  const timeLeft = data.canvasCooldown - data.worldtime;
  const timeLeftPct = timeLeft / data.nextCanvasTime;
  const canUpdate = timeLeft < 0 && !data.updatedCanvas;

  const handleTacMapExport = (image: any) => {
    data.exportedTacMapImage = image;
  };

  const handleColorSelection = () => {
    if (
      colors[data.toolbarUpdatedSelection] !== null &&
      colors[data.toolbarUpdatedSelection] !== undefined
    ) {
      return colors[data.toolbarUpdatedSelection];
    } else {
      return data.toolbarUpdatedSelection;
    }
  };

  return (
    <>
      <Section title="Canvas Options" className={'canvas-options'}>
        <Stack>
          <Stack.Item grow>
            {(!data.updatedCanvas && (
              <Button
                fontSize="10px"
                fluid={1}
                disabled={!canUpdate}
                color="red"
                icon="download"
                className="text-center"
                content="Update Canvas"
                onClick={() => act('updateCanvas')}
              />
            )) || (
              <Button
                fontSize="10px"
                fluid={1}
                color="green"
                icon="bullhorn"
                content="Announce"
                className="text-center"
                onClick={() =>
                  act('selectAnnouncement', {
                    image: data.exportedTacMapImage,
                  })
                }
              />
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fontSize="10px"
              fluid={1}
              color="grey"
              icon="trash"
              content="Clear Canvas"
              className="text-center"
              onClick={() => act('clearCanvas')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fontSize="10px"
              fluid={1}
              color="grey"
              icon="recycle"
              content="Undo"
              className="text-center"
              onClick={() => act('undoChange')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Dropdown
              fluid={1}
              options={colorOptions}
              selected={data.toolbarColorSelection}
              color={data.toolbarColorSelection}
              onSelected={(value) => act('selectColor', { color: value })}
            />
          </Stack.Item>
        </Stack>
        <Stack className={'progress-stack'}>
          <Stack.Item grow>
            {timeLeft > 0 && (
              <ProgressBar
                value={timeLeftPct}
                ranges={{
                  good: [-Infinity, 0.33],
                  average: [0.33, 0.67],
                  bad: [0.67, Infinity],
                }}>
                <Box textAlign="center" fontSize="15px">
                  {Math.ceil(timeLeft / 10)} seconds until the canvas changes
                  can be updated
                </Box>
              </ProgressBar>
            )}
          </Stack.Item>
        </Stack>
      </Section>
      <Section>
        <CanvasLayer
          selection={handleColorSelection()}
          imageSrc={data.flatImage}
          onImageExport={handleTacMapExport}
        />
      </Section>
    </>
  );
};
