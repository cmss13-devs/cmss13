import { type BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { useBackend } from 'tgui/backend';
import { Box, Divider, Input, ProgressBar, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  activeCamera: Camera & { status: BooleanLike };
  cameras: Camera[];
  can_spy: BooleanLike;
  mapRef: string;
  network: string[];
  currentAmmo: number;
  totalAmmo: number;
};

const RedGreenRange: Record<string, [number, number]> = {
  bad: [-Infinity, 0.25],
  average: [0.25, 0.5],
  good: [0.5, Infinity],
};

type Camera = {
  name: string;
  ref: string;
};

export const DropshipGunneryConsole = (props) => {
  return (
    <Window width={215} height={400} theme="crtgreen">
      <Window.Content>
        <MainWindow />
      </Window.Content>
    </Window>
  );
};

export const MainWindow = (props) => {
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <CameraSelector />
      </Stack.Item>
    </Stack>
  );
};

const selectCameras = (cameras: Camera[], searchText = ''): Camera[] => {
  let queriedCameras = cameras.filter((camera: Camera) => !!camera.name);
  if (searchText) {
    const testSearch = createSearch(
      searchText,
      (camera: Camera) => camera.name,
    );
    queriedCameras = queriedCameras.filter(testSearch);
  }
  queriedCameras.sort();

  return queriedCameras;
};

const CameraSelector = (props) => {
  const { act, data } = useBackend<Data>();
  const { searchText, setSearchText } = props;
  const { activeCamera, currentAmmo, totalAmmo } = data;
  const cameras = selectCameras(data.cameras, searchText);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          autoFocus
          expensive
          fluid
          mt={1}
          placeholder="SEL: CAM"
          onInput={(e, value) => setSearchText(value)}
          value={searchText}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section scrollable height={24} title="CAM LST">
          {cameras.map((camera) => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
              key={camera.name}
              title={camera.name}
              className={classes([
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
                activeCamera?.name === camera.name
                  ? 'Button--selected'
                  : 'candystripe',
              ])}
              onClick={() =>
                act('change_camera', {
                  name: camera.name,
                })
              }
            >
              {camera.name}
            </div>
          ))}
        </Section>
      </Stack.Item>
      <Divider />
      <Stack.Item grow>
        <ProgressBar value={currentAmmo / totalAmmo} ranges={RedGreenRange}>
          AMMO_CNT: {currentAmmo} / {totalAmmo}
        </ProgressBar>
        <Box height="5px" />
      </Stack.Item>
      <Box height="5px" />
    </Stack>
  );
};

const AmmoCounter = (props) => {
  const { data } = useBackend<Data>();
  const { currentAmmo, totalAmmo } = data;
  return (
    <>
      <ProgressBar value={currentAmmo / totalAmmo} ranges={RedGreenRange}>
        AMMO_CNT: {currentAmmo} / {totalAmmo}
      </ProgressBar>
      <Box height="5px" />
    </>
  );
};
