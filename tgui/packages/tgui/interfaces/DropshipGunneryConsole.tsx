import { type BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Input,
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
};

type Camera = {
  name: string;
  ref: string;
};

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
const prevNextCamera = (
  cameras: Camera[],
  activeCamera: Camera & { status: BooleanLike },
) => {
  if (!activeCamera || cameras.length < 2) {
    return [];
  }

  const index = cameras.findIndex(
    (camera) => camera.name === activeCamera.name,
  );

  switch (index) {
    case -1: // Current camera is not in the list
      return [cameras[cameras.length - 1].name, cameras[0].name];

    case 0: // First camera
      if (cameras.length === 2) return [cameras[1].name, cameras[1].name]; // Only two

      return [cameras[cameras.length - 1].name, cameras[index + 1].name];

    case cameras.length - 1: // Last camera
      if (cameras.length === 2) return [cameras[0].name, cameras[0].name];

      return [cameras[index - 1].name, cameras[0].name];

    default:
      // Middle camera
      return [cameras[index - 1].name, cameras[index + 1].name];
  }
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
    <Window width={200} height={400}>
      <Window.Content>
        <CameraContent />
      </Window.Content>
    </Window>
  );
};

export const CameraContent = (props) => {
  const [searchText, setSearchText] = useState('');

  return (
    <Stack fill>
      <Stack.Item grow>
        <CameraSelector searchText={searchText} setSearchText={setSearchText} />
      </Stack.Item>
    </Stack>
  );
};

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
