import { createSearch } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Section, Stack } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { EquipmentContext, LazeTarget } from './types';

type CameraItem = {
  name: string;
  type: 'camera' | 'signal';
  ref?: string;
  target_tag?: number;
};

// Extended interface that includes camera data
interface CameraAcquisitionContext extends EquipmentContext {
  available_cameras?: Array<{ name: string; ref: string }>;
  camera_target_id?: string;
}

const selectCameraItems = (
  cameras: Array<{ name: string; ref: string }> = [],
  signals: Array<LazeTarget> = [],
  searchText = '',
): CameraItem[] => {
  // Convert cameras to camera items
  const cameraItems: CameraItem[] = cameras.map((camera) => ({
    name: camera.name,
    type: 'camera' as const,
    ref: camera.ref,
  }));

  // Convert CAS signals to camera items
  const signalItems: CameraItem[] = signals.map((signal) => ({
    name: `${signal.target_name} (Signal)`,
    type: 'signal' as const,
    target_tag: signal.target_tag,
  }));

  let allItems = [...cameraItems, ...signalItems];

  if (searchText) {
    const testSearch = createSearch(
      searchText,
      (item: CameraItem) => item.name,
    );
    allItems = allItems.filter(testSearch);
  }

  allItems.sort((a, b) => a.name.localeCompare(b.name));

  return allItems;
};

const CameraList = (props: {
  readonly searchText: string;
  readonly currentTarget?: string;
  readonly color?: string;
}) => {
  const { act, data } = useBackend<CameraAcquisitionContext>();
  const { searchText, currentTarget, color } = props;

  const cameraItems = selectCameraItems(
    data.available_cameras,
    data.targets_data,
    searchText,
  );

  return (
    <Section
      fill
      scrollable
      style={{
        backgroundColor: 'rgba(0, 0, 0, 0.33)',
        color: color === 'blue' ? '#40628a' : '#9cb93d',
      }}
    >
      <Stack vertical>
        {cameraItems.map((item) => (
          <Stack.Item key={`${item.type}-${item.name}`}>
            <Button
              fluid
              selected={
                item.type === 'signal'
                  ? currentTarget === item.target_tag?.toString()
                  : false
              }
              onClick={() => {
                if (item.type === 'camera') {
                  // Switch to camera
                  act('switch_camera', {
                    name: item.name,
                  });
                } else if (item.type === 'signal') {
                  // Set target to CAS signal
                  act('firemission-dual-offset-camera', {
                    target_id: item.target_tag,
                  });
                }
              }}
              style={{
                backgroundColor:
                  item.type === 'signal' &&
                  currentTarget === item.target_tag?.toString()
                    ? color === 'blue'
                      ? '#40628a'
                      : '#9cb93d'
                    : 'rgba(0, 0, 0, 0.33)',
                color:
                  item.type === 'signal' &&
                  currentTarget === item.target_tag?.toString()
                    ? '#000000'
                    : color === 'blue'
                      ? '#40628a'
                      : '#9cb93d',
                borderColor: color === 'blue' ? '#40628a' : '#9cb93d',
              }}
            >
              <Stack>
                <Stack.Item grow>{item.name}</Stack.Item>
                <Stack.Item>
                  {item.type === 'signal' ? '[SIG]' : '[CAM]'}
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        ))}
        {cameraItems.length === 0 && (
          <Stack.Item>
            <Box
              style={{
                textAlign: 'center',
                color: color === 'blue' ? '#40628a' : '#9cb93d',
                fontStyle: 'italic',
              }}
            >
              No cameras or signals available
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

export const CameraAcquisitionMfdPanel = (props: MfdProps) => {
  const { data } = useBackend<CameraAcquisitionContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const [searchText, setSearchText] = useState('');

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={[{}, {}, {}, {}]}
      leftButtons={[{}, {}, {}, {}]}
      rightButtons={[{}, {}, {}, {}]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
        {},
        {},
        {},
      ]}
    >
      <Box className="NavigationMenu">
        <Stack fill vertical>
          <Stack.Item>
            <Box
              style={{
                textAlign: 'center',
                color: props.color === 'blue' ? '#40628a' : '#9cb93d',
                fontSize: '16px',
                fontWeight: 'bold',
                marginBottom: '10px',
              }}
            >
              Camera Acquisition
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Input
              autoFocus
              fluid
              placeholder="Search cameras and signals..."
              value={searchText}
              onInput={(e, value) => setSearchText(value)}
              style={{
                backgroundColor: 'rgba(0, 0, 0, 0.33)',
                color: props.color === 'blue' ? '#40628a' : '#9cb93d',
                borderColor: props.color === 'blue' ? '#40628a' : '#9cb93d',
              }}
            />
          </Stack.Item>
          <Stack.Item grow>
            <CameraList
              searchText={searchText}
              currentTarget={data.camera_target_id}
              color={props.color}
            />
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
