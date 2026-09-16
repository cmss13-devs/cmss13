import { type BooleanLike, classes } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui/components';
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

const CameraSelector = (props) => {
  const { act, data } = useBackend<Data>();
  const { activeCamera, currentAmmo, totalAmmo } = data;

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section fill scrollable title="CAM LST">
          {data.cameras.map((camera) => (
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
      <Stack.Item>
        <ProgressBar value={currentAmmo / totalAmmo} ranges={RedGreenRange}>
          AMMO_CNT: {currentAmmo} / {totalAmmo}
        </ProgressBar>
        <Box height="5px" />
      </Stack.Item>
      <Box height="5px" />
    </Stack>
  );
};
