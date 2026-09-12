import { type BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Flex,
  Input,
  Popper,
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

const GreedRedRange: Record<string, [number, number]> = {
  good: [-Infinity, 0.25],
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

type Camera = {
  name: string;
  ref: string;
};

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
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

export const DropshipGunneryConsole = (props) => {
  return (
    <Window width={215} height={400}>
      <Window.Content>
        <CameraContent />
      </Window.Content>
    </Window>
  );
};

export const CameraContent = (props) => {
  const [searchText, setSearchText] = useState('');

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <CameraSelector searchText={searchText} setSearchText={setSearchText} fill vertical />
        <AmmoCounter grow vertical />
      </Stack.Item>
    </Stack>
  );
};

// export const AmmoContent = (props) => {
//  return (
//    <Stack >
//      <Stack.Item>
//        <AmmoCounter />
//      </Stack.Item>
//    </Stack>
//  );
// };

const CameraSelector = (props) => {
  const { act, data } = useBackend<Data>();
  const { searchText, setSearchText } = props;
  const { activeCamera } = data;
  const cameras = selectCameras(data.cameras, searchText);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          autoFocus
          expensive
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)}
          value={searchText}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
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
    </Stack>
  );
};

const AmmoCounter = (props) => {
  const { data } = useBackend<Data>();
  const { currentAmmo, totalAmmo } = data;
  return (
      <Stack fill vertical>
        <Stack.Item grow position='absolute' bottom='0'>
          <ProgressBar value={currentAmmo / totalAmmo} ranges={GreedRedRange}>
            CUM_CNT: {currentAmmo} / {totalAmmo}
          </ProgressBar>
          <Box height='5px' />
        </Stack.Item>
      </Stack>
  );
};
