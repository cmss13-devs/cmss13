import { useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Flex,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { ByondUi } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { CanvasLayer } from './CanvasLayer';
import { DrawnMap } from './DrawnMap';

type Line = [
  number,
  number,
  number,
  number,
  string | CanvasGradient | CanvasPattern,
  number,
];
interface TacMapProps {
  toolbarColorSelection: string;
  toolbarUpdatedSelection: string;
  updatedCanvas: boolean;
  themeId: number;
  tempSVGData: Line[][];
  svgData: (string | number | CanvasGradient | CanvasPattern)[];
  canViewTacmap: boolean;
  canDraw: boolean;
  isxeno: boolean;
  isMainship: boolean;
  canViewCanvas: boolean;
  newCanvasFlatImage: Array<string>;
  oldCanvasFlatImage: Array<string>;
  actionQueueChange: number;
  exportedColor: string;
  mapFallback: string;
  mapRef: Array<string>;
  changeToMapName: string;
  currentMenu: string;
  lastUpdateTime: number;
  canvasCooldownDuration: number;
  canvasCooldown: number;
  exportedTacMapImage: HTMLImageElement;
  tacmapReady: boolean;
  canChangeZ: boolean;
  canChangeMapview: boolean;
  zlevel: number;
  maxZlevelOld: number;
  maxZlevel: number;
  minZlevel: number;
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

  const canvasLayerRef = useRef<CanvasLayer>(null);

  const handleTacmapOnClick = (i: number, pageTitle: string) => {
    setPageIndex(i);
    act('menuSelect', {
      selection: pageTitle,
    });
  };

  const saveSVGData = () => {
    const svgData = canvasLayerRef.current?.getSVG();
    return svgData;
  };

  const tryIncrementZ = () => {
    if (
      data.zlevel + 1 <= data.maxZlevel ||
      data.zlevel + 1 <= data.maxZlevelOld
    ) {
      const dat = saveSVGData();
      if (dat !== undefined) {
        data.tempSVGData = dat;
      }
      const newZlevel = data.zlevel + 1;
      act('change_zlevel', { zlevel: newZlevel });
    }
  };

  const tryDecrementZ = () => {
    if (data.zlevel - 1 >= data.minZlevel) {
      const dat = saveSVGData();
      if (dat !== undefined) {
        data.tempSVGData = dat;
      }
      const newZlevel = data.zlevel - 1;
      act('change_zlevel', { zlevel: newZlevel });
    }
  };

  const getZTabs = () => {
    if (data.mapRef.length === 1) return;

    return (
      <>
        <Tabs.Tab
          key={PAGES.length}
          color={data.isxeno ? 'purple' : 'blue'}
          selected={false}
          icon={'plus'}
          onClick={() => tryIncrementZ()}
        >
          Move up
        </Tabs.Tab>
        <Tabs.Tab
          key={PAGES.length + 1}
          color={data.isxeno ? 'purple' : 'blue'}
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
      width={850}
      height={850}
      theme={data.isxeno ? 'hive_status' : 'crtblue'}
    >
      <Window.Content>
        <Flex height="100%" direction="column">
          <Section
            fitted
            width="100%"
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
                  {getZTabs()}
                  {data.canChangeMapview ? (
                    <Tabs.Tab
                      onClick={() => {
                        // Use isMainship to determine what we're switching to
                        // If currently on mainship (isMainship=true), we're switching to ground
                        // If currently on ground (isMainship=false), we're switching to ship
                        const switchingToGround = data.isMainship;

                        // Both ship and ground maps should default to Z-level 1
                        const targetZLevel = 1;

                        act('ChangeMapView', { target_zlevel: targetZLevel });
                        setPageIndex(0);
                        data.tempSVGData = [];
                      }}
                    >
                      Change to {data.changeToMapName}
                    </Tabs.Tab>
                  ) : (
                    ''
                  )}
                </Tabs>
              </Stack.Item>
            </Stack>
          </Section>
          <Flex.Item />
          <Flex.Item grow={1}>
            <PageComponent canvasLayerRef={canvasLayerRef} />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const ViewMapPanel = (props) => {
  const { data } = useBackend<TacMapProps>();

  // byond ui can't resist trying to render
  if (!data.canViewTacmap || data.mapRef.length === 0) {
    return <DrawnMap {...props} />;
  }

  // Handle index mapping for different map types
  const isSingleLevel = data.mapRef.length <= 1;
  const mapIndex = isSingleLevel ? 0 : data.zlevel - 1;

  return (
    <Section fill fitted height="100%">
      <ByondUi
        key={data.lastUpdateTime}
        height="100%"
        width="100%"
        params={{
          id: data.mapRef[mapIndex],
          type: 'map',
          'background-color': 'none',
        }}
      />
    </Section>
  );
};

const OldMapPanel = (props) => {
  const { data } = useBackend<TacMapProps>();

  // Handle index mapping for different map types
  const isSingleLevel = data.mapRef.length <= 1;
  const mapIndex = isSingleLevel ? 0 : data.zlevel - 1;

  return (
    <Section fill>
      {data.canViewCanvas ? (
        <DrawnMap
          svgData={data.svgData}
          flatImage={data.oldCanvasFlatImage[mapIndex]}
          backupImage={data.mapFallback}
          key={data.lastUpdateTime}
          zlevel={data.zlevel}
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

  const { canvasLayerRef } = props;

  // Handle index mapping for different map types
  const isSingleLevel = data.mapRef.length <= 1;
  const mapIndex = isSingleLevel ? 0 : data.zlevel - 1;

  const timeLeftPct = data.canvasCooldown / data.canvasCooldownDuration;
  const canUpdate = data.canvasCooldown <= 0 && !data.updatedCanvas;

  const handleTacMapExport = (image: HTMLImageElement) => {
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
        fitted
        title="Canvas Options"
        textAlign="center"
        width="100%"
        top="5px"
        style={{
          zIndex: '1',
        }}
      >
        <Stack justify="center" align="center">
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
                onClick={() => {
                  act('selectAnnouncement', {
                    image: data.exportedTacMapImage,
                  });
                  data.tempSVGData = [];
                }}
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
              onClick={() => {
                act('clearCanvas');
                data.tempSVGData = [];
              }}
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
          left="10px"
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
      <Section align="center" bottom="60px">
        <CanvasLayer
          ref={canvasLayerRef}
          selection={handleColorSelection(data.toolbarUpdatedSelection)}
          actionQueueChange={data.actionQueueChange}
          imageSrc={data.newCanvasFlatImage[mapIndex]}
          key={data.lastUpdateTime}
          onImageExport={handleTacMapExport}
          zlevel={data.zlevel}
          onUndo={(value: string, newSvgData: Line[][]) => {
            act('selectColor', { color: findColorValue(value) });
            if (newSvgData === undefined) {
              data.tempSVGData = [];
            } else {
              data.tempSVGData = newSvgData;
            }
          }}
          storedData={data.tempSVGData}
          onDraw={(svgData) => {
            act('onDraw', { svgData: svgData });
          }}
        />
      </Section>
    </>
  );
};
