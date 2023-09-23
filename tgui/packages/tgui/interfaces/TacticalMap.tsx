import { useBackend } from '../backend';
import { Button, Dropdown, Section, Stack, ProgressBar, Box } from '../components';
import { Window } from '../layouts';
import { CanvasLayer } from './CanvasLayer';
import { DrawnMap } from './DrawnMap';
import { ByondUi } from '../components';

interface TacMapProps {
  toolbarColorSelection: string;
  toolbarUpdatedSelection: string;
  updatedCanvas: boolean;
  imageSrc: string;
  themeId: number;
  svgData: any;
  flatImage: string;
  mapRef: any;
  currentMenu: string;
  worldtime: any;
  nextCanvasTime: any;
  canvasCooldown: any;
  exportedTacMapImage: any;
}

const PAGES = {
  'view': () => ViewMapPanel,
  'old_canvas': () => OldMapPanel,
  'draw': () => DrawMapPanel,
  'home': () => HomePanel,
};

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

  const PageComponent = PAGES[data.currentMenu]();

  return (
    <Window
      width={650}
      height={750}
      theme={themes[data.themeId]['theme']}
      title={'Tactical Map'}>
      <Window.Content>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const HomePanel = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);

  return (
    <Section fontSize="20px" textAlign="center" title="Tactical Map Options">
      <Stack justify="center" align="center" fontSize="15px">
        <Stack.Item grow>
          <Button
            color={themes[data.themeId]['button-color']}
            content={'tacmap'}
            icon={'map'}
            onClick={() =>
              act('menuSelect', {
                selection: 'view',
              })
            }
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            color={themes[data.themeId]['button-color']}
            content={'old canvas'}
            icon={'eye'}
            onClick={() =>
              act('menuSelect', {
                selection: 'old_canvas',
              })
            }
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            color={themes[data.themeId]['button-color']}
            content={'new canvas'}
            icon={'paintbrush'}
            onClick={() =>
              act('menuSelect', {
                selection: 'draw',
              })
            }
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ViewMapPanel = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);
  return (
    <ByondUi
      params={{
        id: data.mapRef,
        type: 'map',
      }}
      class="TacticalMap"
    />
  );
};

const OldMapPanel = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);
  return (
    <>
      {data.flatImage && (
        <DrawnMap svgData={data.svgData} flatImage={data.flatImage} />
      )}
    </>
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
      <Section>
        <Button
          color={themes[data.themeId]['button-color']}
          content={'home'}
          icon={'home'}
          onClick={() =>
            act('menuSelect', {
              selection: 'home',
            })
          }
        />
        <CanvasLayer
          selection={handleColorSelection()}
          imageSrc={data.imageSrc}
          onImageExport={handleTacMapExport}
        />
      </Section>
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
    </>
  );
};
