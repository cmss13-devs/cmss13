import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from '../components';
import { ByondUi } from '../components';
import { Window } from '../layouts';
import { CanvasLayer } from './CanvasLayer';
import { DrawnMap } from './DrawnMap';

interface TacMapProps {
  toolbarColorSelection: string;
  toolbarUpdatedSelection: string;
  updatedCanvas: boolean;
  themeId: number;
  svgData: any;
  canViewTacmap: boolean;
  canDraw: boolean;
  isxeno: boolean;
  canViewCanvas: boolean;
  newCanvasFlatImage: string;
  oldCanvasFlatImage: string;
  actionQueueChange: number;
  exportedColor: string;
  mapFallback: string;
  mapRef: string;
  currentMenu: string;
  lastUpdateTime: any;
  canvasCooldownDuration: any;
  canvasCooldown: any;
  exportedTacMapImage: any;
  tacmapReady: boolean;
}

const PAGES = [
  {
    title: 'Live Tacmap',
    canOpen: (data: TacMapProps) => {
      return true;
    },
    component: () => ViewMapPanel,
    icon: 'map',
    canAccess: (data: TacMapProps) => {
      return data.canViewTacmap;
    },
  },
  {
    title: 'Map View',
    canOpen: (data: TacMapProps) => {
      return true;
    },
    component: () => OldMapPanel,
    icon: 'eye',
    canAccess: (data: TacMapProps) => {
      return data.canViewCanvas;
    },
  },
  {
    title: 'Canvas',
    canOpen: (data: TacMapProps) => {
      return data.tacmapReady;
    },
    component: () => DrawMapPanel,
    icon: 'paintbrush',
    canAccess: (data: TacMapProps) => {
      return data.canDraw;
    },
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
  black: '#000000',
  red: '#fc0000',
  orange: '#f59a07',
  blue: '#0561f5',
  purple: '#c002fa',
  green: '#02c245',
  brown: '#5c351e',
};

export const TacticalMap = (props) => {
  const { data, act } = useBackend<TacMapProps>();
  const [pageIndex, setPageIndex] = useState(data.canViewTacmap ? 0 : 1);
  const PageComponent = PAGES[pageIndex].component();

  const handleTacmapOnClick = (i: number, pageTitle: string) => {
    setPageIndex(i);
    act('menuSelect', {
      selection: pageTitle,
    });
  };

  return (
    <Window
      width={700}
      height={850}
      theme={data.isxeno ? 'hive_status' : 'crtblue'}
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
                  if (!page.canAccess(data)) {
                    return;
                  }
                  return (
                    <Tabs.Tab
                      key={i}
                      color={data.isxeno ? 'purple' : 'blue'}
                      selected={i === pageIndex}
                      icon={page.icon}
                      onClick={() =>
                        page.canOpen(data)
                          ? handleTacmapOnClick(i, page.title)
                          : null
                      }
                    >
                      {page.canOpen(data) ? page.title : 'loading'}
                    </Tabs.Tab>
                  );
                })}
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

  // byond ui can't resist trying to render
  if (!data.canViewTacmap || data.mapRef === null) {
    return <OldMapPanel {...props} />;
  }

  return (
    <Section fitted height="86%">
      <ByondUi
        params={{
          id: data.mapRef,
          type: 'map',
          'background-color': 'none',
        }}
        className="TacticalMap"
      />
    </Section>
  );
};

const OldMapPanel = (props) => {
  const { data } = useBackend<TacMapProps>();
  return (
    <Section fitted height="86%" align="center" fontSize="30px">
      {data.canViewCanvas ? (
        <DrawnMap
          svgData={data.svgData}
          flatImage={data.oldCanvasFlatImage}
          backupImage={data.mapFallback}
        />
      ) : (
        <Box my="40%">
          <h1>Unauthorized.</h1>
        </Box>
      )}
    </Section>
  );
};

const DrawMapPanel = (props) => {
  const { data, act } = useBackend<TacMapProps>();

  const timeLeftPct = data.canvasCooldown / data.canvasCooldownDuration;
  const canUpdate = data.canvasCooldown <= 0 && !data.updatedCanvas;

  const handleTacMapExport = (image: any) => {
    data.exportedTacMapImage = image;
  };

  const handleColorSelection = (dataSelection: string) => {
    if (colors[dataSelection] !== null && colors[dataSelection] !== undefined) {
      return colors[dataSelection];
    } else {
      return dataSelection;
    }
  };
  const findColorValue = (oldValue: string) => {
    return (Object.keys(colors) as Array<string>).find(
      (key) => colors[key] === (oldValue as string),
    );
  };

  return (
    <>
      <Section
        title="Canvas Options"
        className={'canvas-options'}
        width="688px"
      >
        <Stack height="15px">
          <Stack.Item grow>
            {(!data.updatedCanvas && (
              <Button
                height="20px"
                fluid
                disabled={!canUpdate}
                color="red"
                icon="download"
                className="text-center"
                onClick={() => act('updateCanvas')}
              >
                Update Canvas
              </Button>
            )) || (
              <Button
                height="20px"
                fluid
                color="green"
                icon="bullhorn"
                className="text-center"
                onClick={() =>
                  act('selectAnnouncement', {
                    image: data.exportedTacMapImage,
                  })
                }
              >
                Announce
              </Button>
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Button
              height="20px"
              fluid
              color="grey"
              icon="trash"
              className="text-center"
              onClick={() => act('clearCanvas')}
            >
              Clear Canvas
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              height="20px"
              fluid
              color="grey"
              icon="recycle"
              className="text-center"
              onClick={() => act('undoChange')}
            >
              Undo
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Dropdown
              className="TacticalMapColorPicker"
              menuWidth="15rem"
              options={colorOptions}
              selected={data.toolbarColorSelection}
              color={data.toolbarColorSelection}
              onSelected={(value) => act('selectColor', { color: value })}
              displayText={data.toolbarColorSelection}
            />
          </Stack.Item>
        </Stack>
        <Stack
          className={'progress-stack'}
          position="absolute"
          width="98%"
          style={{ zIndex: '1' }}
          bottom="-40px"
        >
          <Stack.Item grow>
            {data.canvasCooldown > 0 && (
              <ProgressBar
                height="20px"
                value={timeLeftPct}
                backgroundColor="rgba(0, 0, 0, 0.5)"
                ranges={{
                  good: [-Infinity, 0.33],
                  average: [0.33, 0.67],
                  bad: [0.67, Infinity],
                }}
              >
                <Box textAlign="center" fontSize="15px" textColor="white">
                  {Math.ceil(data.canvasCooldown / 10)} seconds until the canvas
                  changes can be updated
                </Box>
              </ProgressBar>
            )}
          </Stack.Item>
        </Stack>
      </Section>
      <Section width="688px" align="center" textAlign="center">
        <CanvasLayer
          selection={handleColorSelection(data.toolbarUpdatedSelection)}
          actionQueueChange={data.actionQueueChange}
          imageSrc={data.newCanvasFlatImage}
          key={data.lastUpdateTime}
          onImageExport={handleTacMapExport}
          onUndo={(value: string) =>
            act('selectColor', { color: findColorValue(value) })
          }
          onDraw={() => act('onDraw')}
        />
      </Section>
    </>
  );
};
